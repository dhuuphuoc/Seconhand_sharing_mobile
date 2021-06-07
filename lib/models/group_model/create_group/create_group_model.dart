import 'package:secondhand_sharing/models/group_model/group/group.dart';

class CreateGroupModel {
  CreateGroupModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  String message;
  Group data;

  factory CreateGroupModel.fromJson(Map<String, dynamic> json) => CreateGroupModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: Group.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data.toJson(),
      };
}
