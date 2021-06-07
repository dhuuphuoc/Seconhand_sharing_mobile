import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

String groupToJson(Group data) => json.encode(data.toJson());

class Group {
  Group({
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

  factory Group.fromJson(Map<String, dynamic> json) => Group(
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
