import 'package:secondhand_sharing/screens/keys/keys.dart';

class APIService {
  // static String apiUrl = "10.0.2.2:5001";
  static String apiUrl = "secondhandsharing.appspot.com";

  static Future<void> handle401StatusCode() async {
    await Keys.navigatorKey.currentState.pushNamed("/login");
  }
}
