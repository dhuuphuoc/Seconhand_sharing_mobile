import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'dart:ui';
import 'package:secondhand_sharing/models/notification_model/cancel_request_model/cancel_request_model.dart';
import 'package:secondhand_sharing/models/notification_model/confirm_sent_model/confirm_sent_model.dart';
import 'package:secondhand_sharing/models/notification_model/request_status_model/request_status_model.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/application/application.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        AndroidInitializationSettings("@mipmap/ic_launcher_foreground");

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

  Future<AndroidNotificationDetails> prepareMessageStyleAndroidNotificationDetails(UserMessage message) async {
    Person person = Person(
        name: "${message.sendFromAccountName}",
        important: true,
        icon: BitmapFilePathAndroidIcon(await APIService.downloadAndSaveFile(
            message.sendFromAccountAvatarUrl, message.sendFromAccountId.toString())));
    MessagingStyleInformation messagingStyleInformation = MessagingStyleInformation(
      person,
      messages: [Message(message.content, message.sendDate, person)],
    );
    return AndroidNotificationDetails(
      messageChannelId,
      'New message',
      'This channel receive message from other users',
      importance: Importance.max,
      color: Colors.green,
      priority: Priority.high,
      styleInformation: messagingStyleInformation,
    );
  }

  Future<void> cancelReceiveRequest(CancelRequestModel data) async {
    await flutterLocalNotificationsPlugin.cancel(data.requestId);
    var notifications = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        .getActiveNotifications();
    if (notifications.where((element) => element.channelId == data.itemId.toString()).length == 1) {
      await flutterLocalNotificationsPlugin.cancel(0);
    }
  }

  Future<S> loadI18n() async {
    var locale = await Devicelocale.currentAsLocale;
    return await S.load(locale);
  }

  Future<AndroidNotificationDetails> prepareReceiveRequestAndroidNotificationDetails(
      ReceiveRequest receiveRequest) async {
    S i18n = await loadI18n();
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        "${i18n.incomingReceiveRequest("<b>${receiveRequest.receiverName}</b>", "<b>${receiveRequest.itemName}</b>", "<b>${receiveRequest.receiveReason}</b>")}",
        contentTitle: "<strong>${receiveRequest.itemName}</strong>",
        htmlFormatContent: true,
        htmlFormatTitle: true,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true);
    String path =
        await APIService.downloadAndSaveFile(receiveRequest.receiverAvatarUrl, receiveRequest.receiverId.toString());
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      receiveRequest.itemId.toString(),
      receiveRequest.itemName,
      'This channel receive notifications from the server',
      groupKey: receiveRequest.itemId.toString(),
      importance: Importance.max,
      color: Colors.green,
      priority: Priority.high,
      largeIcon: receiveRequest.receiverAvatarUrl == null
          ? DrawableResourceAndroidBitmap("person.png")
          : FilePathAndroidBitmap(path),
      styleInformation: bigTextStyleInformation,
      setAsGroupSummary: true,
    ));
    flutterLocalNotificationsPlugin.show(
        0, "<strong>${receiveRequest.itemName}</strong>", null, platformChannelSpecifics);

    return AndroidNotificationDetails(
      receiveRequest.itemId.toString(),
      receiveRequest.itemName,
      'This channel receive notifications from the server',
      groupKey: receiveRequest.itemId.toString(),
      importance: Importance.max,
      color: Colors.green,
      priority: Priority.high,
      largeIcon: receiveRequest.receiverAvatarUrl == null
          ? DrawableResourceAndroidBitmap("person.png")
          : FilePathAndroidBitmap(path),
      styleInformation: bigTextStyleInformation,
    );
  }

  AndroidNotificationDetails prepareDefaultAndroidNotificationDetails() {
    DefaultStyleInformation defaultStyleInformation = DefaultStyleInformation(true, true);

    return AndroidNotificationDetails(
      itemChannel,
      'Notification',
      'This channel receive notifications from the server',
      importance: Importance.max,
      color: Colors.green,
      priority: Priority.high,
      styleInformation: defaultStyleInformation,
    );
  }

  Future<void> sendRequestStatusNotification(RequestStatusModel requestStatus) async {
    S i18n = await loadI18n();
    AndroidNotificationDetails androidPlatformChannelSpecifics = prepareDefaultAndroidNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    if (requestStatus.requestStatus == RequestStatus.receiving)
      await flutterLocalNotificationsPlugin.show(requestStatus.itemId, "<b>${requestStatus.itemName}</b>",
          "${i18n.yourRegistrationWas} <b>${i18n.acceptedLowerCase}</b>", platformChannelSpecifics,
          payload: jsonEncode({"type": "4", "message": requestStatus.toJson()}));
    else {
      await flutterLocalNotificationsPlugin.show(requestStatus.itemId, "<b>${requestStatus.itemName}</b>",
          "${i18n.yourAcceptedRegistrationWas} <b>${i18n.canceledLowerCase}</b>", platformChannelSpecifics,
          payload: jsonEncode({"type": "4", "message": requestStatus.toJson()}));
    }
  }

  Future<void> sendConfirmSentNotification(ConfirmSentModel data) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = prepareDefaultAndroidNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    S i18n = await loadI18n();
    await flutterLocalNotificationsPlugin.show(
        data.itemId,
        "<b>${data.itemName}</b>",
        i18n.confirmSentNotification(data.receiverId == AccessInfo().userInfo.id ? i18n.you : data.receiverName),
        platformChannelSpecifics,
        payload: jsonEncode({"type": "6", "message": data.toJson()}));
  }

  Future<void> sendInboxNotification(UserMessage message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        await prepareMessageStyleAndroidNotificationDetails(message);
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(message.sendFromAccountId, null, null, platformChannelSpecifics,
        payload: jsonEncode({"type": "1", "message": message.toJson()}));
  }

  Future<void> sendIncomingReceiveRequestNotification(ReceiveRequest receiveRequest) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        await prepareReceiveRequestAndroidNotificationDetails(receiveRequest);
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
      case "5":
        var userInfo = await UserServices.getUserInfoById(json["message"]["sendFromAccountId"]);
        Keys.navigatorKey.currentState.pushNamedAndRemoveUntil(
            "/chat", (route) => route.settings.name == "/chat" ? false : true,
            arguments: userInfo);
        break;
      case "2":
      case "3":
      case "4":
      case "6":
        var itemId = json["message"]["itemId"];
        Keys.navigatorKey.currentState.pushNamed("/item/detail", arguments: itemId);
        break;
    }
  }
}
