class Invitation {
  Invitation({
    this.groupId,
    this.groupName,
    this.avatarUrl,
    this.invitationTime,
  });

  int groupId;
  String groupName;
  String avatarUrl;
  DateTime invitationTime;

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        groupId: json["groupId"],
        groupName: json["groupName"],
        avatarUrl: json["avatarUrl"],
        invitationTime: DateTime.parse(json["invitationTime"]),
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "groupName": groupName,
        "avatarUrl": avatarUrl,
      };
}
