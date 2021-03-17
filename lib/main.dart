import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:secondhand_sharing/screens/authentication/login/login_screen.dart';
import 'package:secondhand_sharing/screens/authentication/sign_up/sign_up_screen.dart';

void main() => runApp(TwoHandShareApp());

class TwoHandShareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF0E88FA),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          bodyText2: TextStyle(fontSize: 16, color: Color(0xFF494949)),
          subtitle2: TextStyle(fontSize: 16, color: Color(0xFFA9A9A9)),
        ),
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('vi', ''),
      ],
      routes: {
        "/": (context) => LoginScreen(),
        "/register": (context) => SignUpScreen()
      },
    );
  }
}
