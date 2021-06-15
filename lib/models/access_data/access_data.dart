import 'package:secondhand_sharing/models/user/user_info/user_info.dart';

class AccessData {
  AccessData({
    this.jwToken,
    this.expiration,
    this.roles,
    this.isVerified,
    this.refreshToken,
    this.userInfo,
  });

  String jwToken;
  DateTime expiration;
  String roles;
  bool isVerified;
  String refreshToken;
  UserInfo userInfo;

  factory AccessData.fromJson(Map<String, dynamic> json) => AccessData(
        jwToken: json["jwToken"],
        expiration: DateTime.parse(json["expiration"]),
        roles: json["roles"],
        isVerified: json["isVerified"],
        refreshToken: json["refreshToken"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "jwToken": jwToken,
        "expiration": expiration.toIso8601String(),
        "roles": roles,
        "isVerified": isVerified,
        "refreshToken": refreshToken,
        "userInfo": userInfo
      };
}
