class Group {
  Group({
    this.id,
    this.groupName,
    this.avatarURL,
  });

  int id;
  String groupName;
  String avatarURL;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        groupName: json["groupName"],
        avatarURL: json["avatarURL"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupName": groupName,
      };
}
