import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'package:secondhand_sharing/screens/application/application.dart';

import 'package:secondhand_sharing/screens/authentication/confirm_email/confirm_email.dart';

import 'package:secondhand_sharing/screens/authentication/forgot_password/forgot_password_screen.dart';
import 'package:secondhand_sharing/screens/authentication/login/login_screen.dart';
import 'package:secondhand_sharing/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:secondhand_sharing/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:secondhand_sharing/screens/item/address_screen/address_screen.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/item_detail_screen.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/post_item_screen.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/screens/main/main_screen/main_screen.dart';
import 'package:secondhand_sharing/screens/message/chat_screen/chat_screen.dart';
import 'package:secondhand_sharing/screens/message/message_box_screen/message_box_screen.dart';
import 'package:secondhand_sharing/screens/profile/profile_screen/profile_screen.dart';
import 'package:secondhand_sharing/screens/splash_screen/splash_screen.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/services/firebase_services/firebase_services.dart';
import 'package:secondhand_sharing/services/notification_services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  Application().chattingWithUserId = null;
  Application().watchingItemId = null;
  FirebaseServices.handleFirebaseMessage(remoteMessage);
}

Future<void> main() async {
  // HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await FirebaseServices.initFirebase();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(TwoHandShareApp());
}

class TwoHandShareApp extends StatefulWidget {
  @override
  _TwoHandShareAppState createState() => _TwoHandShareAppState();
}

class _TwoHandShareAppState extends State<TwoHandShareApp> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    // Timer.periodic(Duration(seconds: 4), (timer) {
    //   SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Keys.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        disabledColor: Colors.black45,
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
        selectedRowColor: Color(0xFF9DD0FF),
        errorColor: Colors.red,
        tabBarTheme: TabBarTheme(unselectedLabelColor: Color(0xFF494949), labelColor: Color(0xFF0E88FA)),
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
          subtitle2: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.bold),
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
        "/profile": (context) => ProfileScreen(),
        "/register": (context) => SignUpScreen(),
        "/forgot-password": (context) => ForgotPasswordScreen(),
        "/reset-password": (context) => ResetPasswordScreen(),
        "/confirm-email": (context) => ConfirmEmailScreen(),
        "/home": (context) => MainScreen(),
        "/post-item": (context) => PostItemScreen(),
        "/item/address": (context) => AddressScreen(),
        "/item/detail": (context) => ItemDetailScreen(),
        "/chat": (context) => ChatScreen(),
        "/message-box": (context) => MessageBoxScreen(),
      },
    );
  }
}
