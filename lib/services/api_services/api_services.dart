import 'package:secondhand_sharing/screens/keys/keys.dart';

class APIService {
  static String apiUrl = "secondhandsharing.appspot.com";

  static Future<void> handle401StatusCode() async {
    await Keys.navigatorKey.currentState.pushNamed("/login");
  }
}
