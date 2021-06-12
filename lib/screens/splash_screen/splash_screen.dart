import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country_data.dart';
import 'package:secondhand_sharing/models/address_model/province/province.dart';
import 'package:secondhand_sharing/models/image_model/image_model.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/services/firebase_services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> loadAddress() async {
    Map<int, Province> provinces = await loadProvinceData("assets/data/viet_nam_address.csv");
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
      var result = await UserServices.getUserInfo();
      if (!result) {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/login");
        return;
      }
      String deviceToken = await FirebaseMessaging.instance.getToken();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String oldDeviceToken = sharedPreferences.getString("device_token");
      if (deviceToken != oldDeviceToken) {
        FirebaseServices.saveTokenToDatabase(deviceToken);
      }
      Navigator.pop(context);
      Navigator.pushNamed(context, "/home");
    }
    handleUniLink();
  }

  Future<void> handleUniLink() async {
    String link = await getInitialLink();
    print(link);
    if (link != null) {
      Uri url = Uri.parse(link);
      if (link.contains("confirm")) {
        processConfirmEmailUniLink(url);
      } else if (link.contains("reset")) {
        processUniLink(url);
      }
    }
    uriLinkStream.listen((url) {
      if (link.contains("confirm")) {
        processConfirmEmailUniLink(url);
      } else if (link.contains("reset")) {
        processUniLink(url);
      }
    });
  }

  void processConfirmEmailUniLink(Uri url) {
    String userId = url.queryParameters["userid"];
    String code = url.queryParameters["code"];
    Keys.navigatorKey.currentState.pushNamed("/confirm-email", arguments: {"userId": userId, "code": code});
  }

  void processUniLink(Uri url) {
    print(url);
    String userId = url.queryParameters["userid"];
    String code = url.queryParameters["code"].replaceAll(" ", "+");
    Keys.navigatorKey.currentState.pushNamed("/reset-password", arguments: {"userId": userId, "code": code});
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("locale", Localizations.localeOf(context).toString());
    await loadAddress();

    if (!kIsWeb) await loadImages(context);
    await loadToken();
  }

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(FirebaseServices.handleFirebaseMessage);
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
            Align(alignment: Alignment.bottomCenter, child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
