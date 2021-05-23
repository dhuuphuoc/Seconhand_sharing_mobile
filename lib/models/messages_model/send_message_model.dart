import 'package:secondhand_sharing/models/messages_model/user_message.dart';

class SendMessageModel {
  SendMessageModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  String message;
  UserMessage data;

  factory SendMessageModel.fromJson(Map<String, dynamic> json) =>
      SendMessageModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: UserMessage.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data.toJson(),
      };
}
