import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';

class AccessInfo {
  String token;
  UserInfo userInfo;

  static final AccessInfo _singleton = AccessInfo._create();

  factory AccessInfo() {
    return _singleton;
  }

  AccessInfo._create();
}
