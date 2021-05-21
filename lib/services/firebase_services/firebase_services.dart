import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';

class FirebaseServices {
  static String deviceToken;

  static Future<void> saveTokenToDatabase(String token) async {
    deviceToken = token;
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
