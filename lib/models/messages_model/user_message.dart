class UserMessage {
  UserMessage({
    this.id,
    this.content,
    this.sendDate,
    this.sendFromAccountId,
    this.sendToAccountId,
    this.sendFromAccountName,
    this.sendToAccountName,
    this.sendFromAccountAvatarUrl,
  });

  int id;
  String content;
  DateTime sendDate;
  int sendFromAccountId;
  int sendToAccountId;
  String sendFromAccountName;
  String sendToAccountName;
  String sendFromAccountAvatarUrl;

  factory UserMessage.fromJson(Map<String, dynamic> json) => UserMessage(
        id: json["id"],
        content: json["content"],
        sendDate: DateTime.parse(json["sendDate"]),
        sendFromAccountId: json["sendFromAccountId"],
        sendToAccountId: json["sendToAccountId"],
        sendFromAccountName: json["sendFromAccountName"],
        sendToAccountName: json["sendToAccountName"],
        sendFromAccountAvatarUrl: json["sendFromAccountAvatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "sendToAccountId": sendToAccountId,
        "sendFromAccountId": sendFromAccountId,
        "sendDate": sendDate?.toIso8601String(),
      };
}
