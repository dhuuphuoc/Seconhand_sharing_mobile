class JoinRequestModel {
  JoinRequestModel({
    this.userId,
    this.fullName,
    this.groupId,
    this.groupName,
    this.avatarUrl,
  });

  int userId;
  String fullName;
  int groupId;
  String groupName;
  String avatarUrl;

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) => JoinRequestModel(
        userId: json["userId"],
        fullName: json["fullName"],
        groupId: json["groupId"],
        groupName: json["groupName"],
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "fullName": fullName,
        "groupId": groupId,
        "groupName": groupName,
        "avatarUrl": avatarUrl,
      };
}
