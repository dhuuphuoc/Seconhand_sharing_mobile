import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/invitation/invitation.dart';
import 'package:secondhand_sharing/models/message/user_message.dart';
import 'package:secondhand_sharing/models/notification/accep_invitation_model/accept_invitation_model.dart';
import 'package:secondhand_sharing/models/notification/cancel_request_model/cancel_request_model.dart';
import 'package:secondhand_sharing/models/notification/confirm_sent_model/confirm_sent_model.dart';
import 'package:secondhand_sharing/models/notification/join_request_model/join_request_model.dart';
import 'package:secondhand_sharing/models/notification/request_status_model/request_status_model.dart';
import 'package:secondhand_sharing/models/receive_request/receive_request.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/application/application.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/services/notification_services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FirebaseServices {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<bool> saveTokenToDatabase(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("device_token", token);
    Uri url = Uri.https(APIService.apiUrl, "/FirebaseToken");
    var response = await http.post(url, body: jsonEncode({"firebaseToken": token}), headers: {
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
    switch (remoteMessage.data["type"]) {
      case "1":
        UserMessage message = UserMessage.fromJson(jsonDecode(remoteMessage.data["message"]));
        if (Application().chattingWithUserId == message.sendFromAccountId) return;
        NotificationService().sendInboxNotification(message);
        break;
      case "2":
        ReceiveRequest receiveRequest = ReceiveRequest.fromJson(jsonDecode(remoteMessage.data["message"]));
        if (Application().watchingItemId == receiveRequest.itemId) return;
        NotificationService().sendIncomingReceiveRequestNotification(receiveRequest);
        break;
      case "3":
        var data = CancelRequestModel.fromJson(jsonDecode(remoteMessage.data["message"]));
        NotificationService().cancelReceiveRequest(data);
        break;
      case "4":
        var data = RequestStatusModel.fromJson(jsonDecode(remoteMessage.data["message"]));
        if (Application().watchingItemId == data.itemId) return;
        NotificationService().sendRequestStatusNotification(data);
        break;
      case "5":
        UserMessage message = UserMessage.fromJson(jsonDecode(remoteMessage.data["message"]));
        if (Application().chattingWithUserId == message.sendFromAccountId) return;
        message.content = S.current.thanksNotification(message.content);
        NotificationService().sendInboxNotification(message);
        break;
      case "6":
        var data = ConfirmSentModel.fromJson(jsonDecode(remoteMessage.data["message"]));
        if (Application().watchingItemId == data.itemId) return;
        NotificationService().sendConfirmSentNotification(data);
        break;
      case "7":
        var data = Invitation.fromJson(jsonDecode(remoteMessage.data["message"]));
        NotificationService().sendIncomingInvitation(data);
        break;
      case "8":
        var data = AcceptInvitationModel.fromJson(jsonDecode(remoteMessage.data["message"]));
        NotificationService().sendAcceptedInvitation(data);
        break;
      case "9":
        var data = JoinRequestModel.fromJson(jsonDecode(remoteMessage.data["message"]));
        NotificationService().sendJoinRequestNotification(data);
        break;
    }
  }

  static Future<bool> removeTokenFromDatabase() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String deviceToken = sharedPreferences.get("device_token");
    Uri url = Uri.https(APIService.apiUrl, "/FirebaseToken");
    var response = await http.delete(url, body: jsonEncode({"firebaseToken": deviceToken}), headers: {
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
    FirebaseMessaging.instance.onTokenRefresh.listen((deviceToken) async {
      await saveTokenToDatabase(deviceToken);
    });
  }
}
