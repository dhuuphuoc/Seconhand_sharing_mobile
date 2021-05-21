class Message {
  Message({
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

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        content: json["content"],
        sendDate: DateTime.parse(json["sendDate"]),
        sendFromAccountId: json["sendFromAccountId"],
        sendToAccountId: json["sendToAccountId"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "sendToAccountId": sendToAccountId,
      };
}
