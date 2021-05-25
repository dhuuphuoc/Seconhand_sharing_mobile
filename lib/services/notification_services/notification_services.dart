import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String messageChannelId = "message_channel";
  int summaryNotificationId;
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> sendNotification(RemoteMessage message) async {
    List<String> lines = [];
    for (var key in message.data.keys) {
      lines.add("${key.toString()} : ${message.data[key]}");
    }
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            '1', 'Message', 'This channel receive message from other users',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: InboxStyleInformation(lines),
            showWhen: true);
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message.notification.title,
        "${message.notification.body}", platformChannelSpecifics,
        payload: jsonEncode(message.data));
  }

  Future<void> sendInboxNotification(UserMessage message) async {
    Person person = Person(name: message.sendFromAccountName);
    final MessagingStyleInformation messagingStyleInformation =
        MessagingStyleInformation(
      person,
      messages: [Message(message.content, message.sendDate, person)],
    );

    var notifications = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .getActiveNotifications();
    bool isEmpty = !notifications
        .any((notification) => notification.channelId == messageChannelId);
    print(summaryNotificationId);
    if (isEmpty) {
      AndroidNotificationDetails summaryPlatformChannelSpecifics =
          AndroidNotificationDetails(
        messageChannelId,
        'New message',
        'This channel receive message from other users',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: messagingStyleInformation,
        groupKey: "new_message",
        // setAsGroupSummary: summaryNotificationId == message.sendFromAccountId,
        setAsGroupSummary: true,
      );

      NotificationDetails summaryChannelSpecifics =
          NotificationDetails(android: summaryPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          // message.sendFromAccountId,
          -id++,
          message.sendFromAccountName,
          "${message.content}",
          summaryChannelSpecifics,
          payload: jsonEncode({"type": "1", "message": message.toJson()}));
    }
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      messageChannelId,
      'New message',
      'This channel receive message from other users',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: messagingStyleInformation,
      groupKey: "new_message",
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        message.sendFromAccountId,
        message.sendFromAccountName,
        "${message.content}",
        platformChannelSpecifics,
        payload: jsonEncode({"type": "1", "message": message.toJson()}));
  }

  int id = 0;
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print("wrong");
  }

  Future<void> selectNotification(String payload) async {
    var json = jsonDecode(payload);
    print(json);
    switch (json["type"]) {
      case "1":
        var userInfo = await UserServices.getUserInfoById(
            json["message"]["sendFromAccountId"]);
        Keys.navigatorKey.currentState.pushNamed("/chat", arguments: userInfo);
        break;
    }
  }
}
