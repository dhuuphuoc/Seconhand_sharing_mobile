import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';

class LoginModel {
  LoginModel({
    this.succeeded,
    this.message,
    this.accessData,
  });

  bool succeeded;
  String message;
  AccessData accessData;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        succeeded: json["succeeded"],
        message: json["message"],
        accessData: AccessData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": accessData.toJson(),
      };
}

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
