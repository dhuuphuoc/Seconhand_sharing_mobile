class ResetPasswordModel {
  ResetPasswordModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  String message;
  String data;

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data,
      };
}

class CodeResetPassword {
  CodeResetPassword({
    this.userId,
    this.code,
  });

  String userId;
  String code;

  factory CodeResetPassword.fromJson(Map<String, dynamic> json) =>
      CodeResetPassword(
        userId: json["userId"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "code": code,
  };
}