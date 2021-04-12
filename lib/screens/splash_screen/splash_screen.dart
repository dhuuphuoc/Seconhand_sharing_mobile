import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country_data.dart';

import 'package:secondhand_sharing/models/address_model/province/province.dart';

import 'package:secondhand_sharing/models/user_model/user_singleton/access_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> loadToken(BuildContext context) async {
    print("start");
    Map<int, Province> provinces =
        await loadProvinceData("assets/data/viet_nam_address.csv");
    Country vn = Country(84, S.of(context).vietNam, provinces);
    CountryData().vn = vn;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    if (token == null) {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/login");
    } else {
      AccessInfo userSingleton = AccessInfo();
      userSingleton.token = token;
      Navigator.pop(context);
      Navigator.pushNamed(context, "/home");
    }
  }

  @override
  void initState() {
    loadToken(context);
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
