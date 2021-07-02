class GroupEvent {
  GroupEvent({
    this.id,
    this.eventName,
    this.startDate,
    this.endDate,
    this.content,
    this.groupId,
    this.groupName,
    this.groupAvatar,
  });

  int id;
  String eventName;
  DateTime startDate;
  DateTime endDate;
  String content;
  int groupId;
  String groupName;
  String groupAvatar;

  factory GroupEvent.fromJson(Map<String, dynamic> json) => GroupEvent(
        id: json["id"],
        eventName: json["eventName"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        content: json["content"],
        groupId: json["groupId"],
        groupName: json["groupName"],
        groupAvatar: json["groupAvatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventName": eventName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "content": content,
        "groupId": groupId,
        "groupName": groupName,
        "groupAvatar": groupAvatar,
      };
}
