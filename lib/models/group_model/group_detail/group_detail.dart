import 'dart:convert';

GroupDetail groupDetailFromJson(String str) => GroupDetail.fromJson(json.decode(str));

String groupDetailToJson(GroupDetail data) => json.encode(data.toJson());

class GroupDetail {
  GroupDetail({
    this.id,
    this.groupName,
    this.description,
    this.createDate,
    this.rules,
  });

  int id;
  String groupName;
  String description;
  DateTime createDate;
  String rules;

  factory GroupDetail.fromJson(Map<String, dynamic> json) => GroupDetail(
    id: json["id"],
    groupName: json["groupName"],
    description: json["description"],
    createDate: DateTime.parse(json["createDate"]),
    rules: json["rules"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupName": groupName,
    "description": description,
    "createDate": createDate.toIso8601String(),
    "rules": rules,
  };
}
