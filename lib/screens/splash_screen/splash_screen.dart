import 'package:flutter/material.dart';
import 'package:secondhand_sharing/user_singleton/user_singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  Future<void> loadToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    if (token == null) {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/login");
    } else {
      UserSingleton userSingleton = UserSingleton();
      userSingleton.token = token;
      Navigator.pop(context);
      Navigator.pushNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    loadToken(context);
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
