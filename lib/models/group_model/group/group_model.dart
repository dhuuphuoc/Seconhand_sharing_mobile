import 'package:secondhand_sharing/models/group_model/group/group.dart';

class GroupModel {
  GroupModel({
    this.succeeded,
    this.message,
    this.data,
    this.items,
  });

  bool succeeded;
  String message;
  Group data;
  List<Group> items;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    succeeded: json["succeeded"],
    message: json["message"],
    data: Group.fromJson(json["data"]),
    items: List<Group>.from(json["data"].map((x) => Group.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "succeeded": succeeded,
    "message": message,
    "data": data.toJson(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}
