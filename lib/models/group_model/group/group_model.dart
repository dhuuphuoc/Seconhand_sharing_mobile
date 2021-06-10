import 'package:secondhand_sharing/models/group_model/group/group.dart';

class GroupModel {
  GroupModel({
    this.succeeded,
    this.message,
    this.items,
  });

  bool succeeded;
  String message;
  List<Group> items;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    succeeded: json["succeeded"],
    message: json["message"],
    items: List<Group>.from(json["data"].map((x) => Group.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "succeeded": succeeded,
    "message": message,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}
