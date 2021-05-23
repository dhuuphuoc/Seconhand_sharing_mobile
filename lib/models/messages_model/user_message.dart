class UserMessage {
  UserMessage({
    this.id,
    this.content,
    this.sendDate,
    this.sendFromAccountId,
    this.sendToAccountId,
  });

  int id;
  String content;
  DateTime sendDate;
  int sendFromAccountId;
  int sendToAccountId;

  factory UserMessage.fromJson(Map<String, dynamic> json) => UserMessage(
        id: json["id"] != null ? json["id"] : json["Id"],
        content: json["content"] != null ? json["content"] : json["Content"],
        sendDate: DateTime.parse(
            json["sendDate"] != null ? json["sendDate"] : json["SendDate"]),
        sendFromAccountId: json["sendFromAccountId"] != null
            ? json["sendFromAccountId"]
            : json["SendFromAccountId"],
        sendToAccountId: json["sendToAccountId"] != null
            ? json["sendToAccountId"]
            : json["SendToAccountId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "sendToAccountId": sendToAccountId,
        "sendFromAccountId": sendFromAccountId,
        "sendDate": sendDate?.toIso8601String(),
      };
}
