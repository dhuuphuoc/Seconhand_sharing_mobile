class Group {
  Group({
    this.id,
    this.groupName,
  });

  int id;
  String groupName;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        groupName: json["groupName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupName": groupName,
      };
}
