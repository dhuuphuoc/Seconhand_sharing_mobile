import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/views/LoginScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:secondhand_sharing/views/SignUpScreen.dart';

void main() => runApp(TwoHandShareApp());

class TwoHandShareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
