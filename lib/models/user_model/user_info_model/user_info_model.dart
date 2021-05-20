import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';

class UserInfoModel {
  UserInfoModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  UserInfo data;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: UserInfo.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data.toJson(),
      };
}
