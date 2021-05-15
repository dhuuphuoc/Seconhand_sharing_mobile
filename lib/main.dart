import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:secondhand_sharing/screens/authentication/forgot_password/forgot_password_screen.dart';
import 'package:secondhand_sharing/screens/authentication/login/login_screen.dart';
import 'package:secondhand_sharing/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:secondhand_sharing/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:secondhand_sharing/screens/item/address_screen/address_screen.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/item_detail_screen.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/post_item_screen.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/screens/main/main_screen/main_screen.dart';
import 'package:secondhand_sharing/screens/splash_screen/splash_screen.dart';
import 'package:uni_links/uni_links.dart';

void main() => runApp(TwoHandShareApp());

class TwoHandShareApp extends StatefulWidget {
  @override
  _TwoHandShareAppState createState() => _TwoHandShareAppState();
}

class _TwoHandShareAppState extends State<TwoHandShareApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      navigatorKey: Keys.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        disabledColor: Colors.black45,
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
        selectedRowColor: Color(0xFF9DD0FF),
        errorColor: Colors.red,
        tabBarTheme: TabBarTheme(
            unselectedLabelColor: Color(0xFF494949),
            labelColor: Color(0xFF0E88FA)),
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Color(0xFF0E88FA)),
          titleTextStyle: TextStyle(color: Color(0xFF494949)),
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0E88FA),
        ),
        primaryColor: Color(0xFF0E88FA),
        textTheme: TextTheme(
          headline2: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
          headline3: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          bodyText2: TextStyle(fontSize: 15),
          subtitle2: TextStyle(
              fontSize: 14, color: Colors.black45, fontWeight: FontWeight.bold),
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
        "/": (context) => SplashScreen(),
        "/login": (context) => LoginScreen(),
        "/register": (context) => SignUpScreen(),
        "/forgot-password": (context) => ForgotPasswordScreen(),
        "/reset-password": (context) => ResetPasswordScreen(),
        "/home": (context) => MainScreen(),
        "/post-item": (context) => PostItemScreen(),
        "/item/address": (context) => AddressScreen(),
        "/item/detail": (context) => ItemDetailScreen(),
      },
    );
  }
}
