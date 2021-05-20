class ReceiveRequestModel {
  ReceiveRequestModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  int data;

  factory ReceiveRequestModel.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestModel(
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
