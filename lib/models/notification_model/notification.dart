class UserNotification {
  UserNotification({
    this.id,
    this.type,
    this.data,
    this.userId,
    this.createTime,
  });

  int id;
  int type;
  String data;
  int userId;
  DateTime createTime;

  factory UserNotification.fromJson(Map<String, dynamic> json) => UserNotification(
        id: json["id"],
        type: json["type"],
        data: json["data"],
        userId: json["userId"],
        createTime: DateTime.parse(json["createTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "data": data,
        "userId": userId,
        "createTime": createTime.toIso8601String(),
      };
}
