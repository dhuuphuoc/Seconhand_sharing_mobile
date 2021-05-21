import 'package:secondhand_sharing/models/messages_model/message.dart';

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
  List<Message> messages;

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        succeeded: json["succeeded"],
        message: json["message"],
        messages:
            List<Message>.from(json["data"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "succeeded": succeeded,
        "message": message,
        "data": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}
