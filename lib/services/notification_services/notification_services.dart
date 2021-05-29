import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';

import 'package:secondhand_sharing/models/notification_model/cancel_request_model/cancel_request_model.dart';
import 'package:secondhand_sharing/models/notification_model/request_status_model/request_status_model.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';
import 'package:secondhand_sharing/screens/application/application.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String messageChannelId = "message_channel";
  String itemChannel = "item_channel";
  int summaryNotificationId;
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
  }

  AndroidNotificationDetails prepareMessageStyleAndroidNotificationDetails(UserMessage message) {
    Person person = Person(name: "${message.sendFromAccountName}", important: true);
    MessagingStyleInformation messagingStyleInformation = MessagingStyleInformation(
      person,
      messages: [Message(message.content, message.sendDate, person)],
    );
    return AndroidNotificationDetails(
      messageChannelId,
      'New message',
      'This channel receive message from other users',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: messagingStyleInformation,
    );
  }

  Future<void> showSummaryNotification(ReceiveRequest receiveRequest) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        "${S.current.incomingReceiveRequest(receiveRequest.receiverName, receiveRequest.itemName, receiveRequest.receiveReason)}",
        contentTitle: "<strong>${receiveRequest.itemName}</strong>",
        htmlFormatContent: true,
        htmlFormatTitle: true,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true);
    var details = AndroidNotificationDetails(
      itemChannel,
      'Notification',
      'This channel receive notifications from the server',
      groupKey: receiveRequest.itemId.toString(),
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
      setAsGroupSummary: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: details);
    await flutterLocalNotificationsPlugin.show(
        -receiveRequest.itemId, "<strong>${receiveRequest.itemName}</strong>", null, platformChannelSpecifics,
        payload: jsonEncode({"type": "2", "message": receiveRequest.toJson()}));
  }

  AndroidNotificationDetails prepareReceiveRequestAndroidNotificationDetails(ReceiveRequest receiveRequest) {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        "${S.current.incomingReceiveRequest(receiveRequest.receiverName, receiveRequest.itemName, receiveRequest.receiveReason)}",
        contentTitle: "<strong>${receiveRequest.itemName}</strong>",
        htmlFormatContent: true,
        htmlFormatTitle: true,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true);

    return AndroidNotificationDetails(
      itemChannel,
      'Notification',
      'This channel receive notifications from the server',
      groupKey: receiveRequest.itemId.toString(),
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
    );
  }

  AndroidNotificationDetails prepareRequestAcceptedAndroidNotificationDetails() {
    DefaultStyleInformation defaultStyleInformation = DefaultStyleInformation(true, true);

    return AndroidNotificationDetails(
      itemChannel,
      'Notification',
      'This channel receive notifications from the server',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: defaultStyleInformation,
    );
  }

  Future<void> sendRequestStatusNotification(RequestStatusModel requestStatus) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = prepareRequestAcceptedAndroidNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    if (requestStatus.requestStatus == RequestStatus.receiving)
      await flutterLocalNotificationsPlugin.show(requestStatus.itemId, "<b>${requestStatus.itemName}</b>",
          S.current.acceptedRequestNotification, platformChannelSpecifics,
          payload: jsonEncode({"type": "4", "message": requestStatus.toJson()}));
    else {
      await flutterLocalNotificationsPlugin.show(requestStatus.itemId, "<b>${requestStatus.itemName}</b>",
          S.current.cancelAcceptRequestNotification, platformChannelSpecifics,
          payload: jsonEncode({"type": "4", "message": requestStatus.toJson()}));
    }
  }

  Future<void> sendInboxNotification(UserMessage message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = prepareMessageStyleAndroidNotificationDetails(message);
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(message.sendFromAccountId, null, null, platformChannelSpecifics,
        payload: jsonEncode({"type": "1", "message": message.toJson()}));
  }

  Future<void> sendIncomingReceiveRequestNotification(ReceiveRequest receiveRequest) async {
    var notifications = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        .getActiveNotifications();
    if (!notifications.any((notification) => notification.id == -receiveRequest.itemId)) {
      await showSummaryNotification(receiveRequest);
    }
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        prepareReceiveRequestAndroidNotificationDetails(receiveRequest);
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        receiveRequest.id, "<strong>${receiveRequest.itemName}</strong>", null, platformChannelSpecifics,
        payload: jsonEncode({"type": "2", "message": receiveRequest.toJson()}));
  }

  int id = 0;
  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    print("wrong");
  }

  Future<void> selectNotification(String payload) async {
    var json = jsonDecode(payload);
    print(json);
    switch (json["type"]) {
      case "1":
        var userInfo = await UserServices.getUserInfoById(json["message"]["sendFromAccountId"]);
        Keys.navigatorKey.currentState.pushNamed("/chat", arguments: userInfo);
        break;
      case "2":
      case "3":
      case "4":
        var itemId = json["message"]["itemId"];
        Keys.navigatorKey.currentState.pushNamed("/item/detail", arguments: itemId);
        break;
    }
  }
}
