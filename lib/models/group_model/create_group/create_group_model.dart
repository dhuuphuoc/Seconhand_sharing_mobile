class GroupModel {
  GroupModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  String message;
  GroupDataModel data;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    succeeded: json["succeeded"],
    message: json["message"],
    data: GroupDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "succeeded": succeeded,
    "message": message,
    "data": data.toJson(),
  };
}

class GroupDataModel {
  GroupDataModel({
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

  factory GroupDataModel.fromJson(Map<String, dynamic> json) => GroupDataModel(
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