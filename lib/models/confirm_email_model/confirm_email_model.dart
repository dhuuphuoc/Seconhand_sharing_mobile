class ConfirmEmailModel {
  ConfirmEmailModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  String message;
  String data;

  factory ConfirmEmailModel.fromJson(Map<String, dynamic> json) =>
      ConfirmEmailModel(
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
