class LoginModel {
  LoginModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  String message;
  Data data;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.jwToken,
    this.expiration,
    this.roles,
    this.isVerified,
    this.refreshToken,
  });

  String jwToken;
  DateTime expiration;
  String roles;
  bool isVerified;
  String refreshToken;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        jwToken: json["jwToken"],
        expiration: DateTime.parse(json["expiration"]),
        roles: json["roles"],
        isVerified: json["isVerified"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "jwToken": jwToken,
        "expiration": expiration.toIso8601String(),
        "roles": roles,
        "isVerified": isVerified,
        "refreshToken": refreshToken,
      };
}
