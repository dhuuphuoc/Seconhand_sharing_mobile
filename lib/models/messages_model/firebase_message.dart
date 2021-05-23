import 'package:secondhand_sharing/models/messages_model/user_message.dart';

class FirebaseMessage {
  FirebaseMessage({
    this.type,
    this.message,
  });

  int type;
  UserMessage message;

  factory FirebaseMessage.fromJson(Map<String, dynamic> json) =>
      FirebaseMessage(
        type: json["type"],
        message: UserMessage.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": message.toJson(),
      };
}
