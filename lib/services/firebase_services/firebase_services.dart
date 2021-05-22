import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices {
  static Future<void> saveTokenToDatabase(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("device_token", token);
    var doc = FirebaseFirestore.instance
        .collection('users')
        .doc(AccessInfo().userInfo.id.toString());
    var data = await doc.get();
    if (data.exists) {
      await doc.update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    } else {
      await doc.set({
        'tokens': FieldValue.arrayUnion([token]),
      });
    }
  }

  static Future<void> removeTokenFromDatabase() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String deviceToken = sharedPreferences.get("device_token");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(AccessInfo().userInfo.id.toString())
        .update({
      'tokens': FieldValue.arrayRemove([deviceToken]),
    });
  }

  static Future<void> initFirebase() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseMessaging.instance.app.setAutomaticResourceManagementEnabled(false);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.instance.onTokenRefresh.listen((deviceToken) {
      removeTokenFromDatabase();
      saveTokenToDatabase(deviceToken);
    });
  }
}
