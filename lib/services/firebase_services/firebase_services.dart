import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:secondhand_sharing/models/messages_model/firebase_message.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/services/notification_services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FirebaseServices {
  static int chattingWithUserId;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'flutter_firebase_notifications_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<bool> saveTokenToDatabase(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("device_token", token);
    Uri url = Uri.https(APIService.apiUrl, "/FirebaseToken");
    var response = await http
        .post(url, body: jsonEncode({"firebaseToken": token}), headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  }

  static void handleFirebaseMessage(RemoteMessage remoteMessage) {
    print(remoteMessage.data);
    FirebaseMessage firebaseMessage = FirebaseMessage();
    firebaseMessage.type = int.parse(remoteMessage.data["type"]);
    firebaseMessage.message =
        UserMessage.fromJson(jsonDecode(remoteMessage.data["message"]));
    switch (firebaseMessage.type) {
      case 1:
        if (FirebaseServices.chattingWithUserId !=
            firebaseMessage.message.sendFromAccountId) {
          NotificationService().sendInboxNotification(firebaseMessage);
        }
        break;
    }
  }

  static Future<bool> removeTokenFromDatabase() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String deviceToken = sharedPreferences.get("device_token");
    Uri url = Uri.https(APIService.apiUrl, "/FirebaseToken");
    var response = await http.delete(url,
        body: jsonEncode({"firebaseToken": deviceToken}),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      sharedPreferences.remove("device_token");
      return true;
    } else
      return false;
  }

  static Future<void> initFirebase() async {
    await Firebase.initializeApp();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.instance.onTokenRefresh.listen((deviceToken) async {
      await saveTokenToDatabase(deviceToken);
    });
  }
}
