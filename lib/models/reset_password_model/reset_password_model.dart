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