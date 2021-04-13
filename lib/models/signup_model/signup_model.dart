class RegisterModel {
  RegisterModel({
    this.succeeded,
    this.message,
    this.data,
});
  bool succeeded;
  String message;
  String data;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
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