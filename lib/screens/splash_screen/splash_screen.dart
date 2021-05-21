import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country_data.dart';

import 'package:secondhand_sharing/models/address_model/province/province.dart';
import 'package:secondhand_sharing/models/image_model/image_model.dart';
import 'package:secondhand_sharing/models/reset_password_model/reset_password_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Future<void> saveTokenToDatabase(int userId, String token) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId.toString())
  //       .update({
  //     'tokens': FieldValue.arrayUnion([token]),
  //   });
  // }
  //
  // Future<void> initFirebase() async {
  //   await Firebase.initializeApp();
  //
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   print(settings.authorizationStatus);
  // }

  Future<void> loadAddress() async {
    Map<int, Province> provinces =
        await loadProvinceData("assets/data/viet_nam_address.csv");
    Country vn = Country(84, S.of(context).vietNam, provinces);
    CountryData().vn = vn;
  }

  Future<void> loadImages(BuildContext context) async {
    if (await Permission.storage.isDenied) {
      if (await Permission.storage.request().isDenied) {
        return;
      }
    }
    ImageModel().loadImages();
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    if (token == null) {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/login");
    } else {
      AccessInfo userSingleton = AccessInfo();
      userSingleton.token = token;
      await UserServices.getUserInfo();
      // String deviceToken = await FirebaseMessaging.instance.getToken();
      // print(deviceToken);
      // saveTokenToDatabase(userSingleton.userInfo.id, deviceToken);
      // FirebaseMessaging.instance.onTokenRefresh.listen((deviceToken) {
      //   saveTokenToDatabase(userSingleton.userInfo.id, deviceToken);
      // });
      Navigator.pop(context);
      Navigator.pushNamed(context, "/home");
    }
    handleUniLink();
  }

  Future<void> handleUniLink() async {
    String link = await getInitialLink();
    if (link != null) {
      Uri url = Uri.parse(link);
      processUniLink(url);
    }
    uriLinkStream.listen((url) {
      processUniLink(url);
    });
  }

  void processUniLink(Uri url) {
    print(url);
    String userId = url.queryParameters["userid"];
    String code = url.queryParameters["code"].replaceAll(" ", "+");
    Keys.navigatorKey.currentState.pushNamed("/reset-password",
        arguments: {"userId": userId, "code": code});
  }

  Future<void> loadData() async {
    await loadAddress();
    // await initFirebase();
    if (!kIsWeb) await loadImages(context);
    await loadToken();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Stack(
          children: [
            Center(
              child: Image.asset("assets/images/login_icon.png"),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
