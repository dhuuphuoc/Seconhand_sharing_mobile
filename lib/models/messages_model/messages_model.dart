import 'package:secondhand_sharing/models/messages_model/user_message.dart';

class MessagesModel {
  MessagesModel({
    this.pageNumber,
    this.pageSize,
    this.succeeded,
    this.message,
    this.messages,
  });

  int pageNumber;
  int pageSize;
  bool succeeded;
  String message;
  List<UserMessage> messages;

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        succeeded: json["succeeded"],
        message: json["message"],
        messages: List<UserMessage>.from(
            json["data"].map((x) => UserMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "succeeded": succeeded,
        "message": message,
        "data": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}
