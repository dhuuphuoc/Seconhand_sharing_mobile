// To parse this JSON data, do
//
//     final itemDetailModel = itemDetailModelFromJson(jsonString);

import 'dart:convert';

import 'group_detail.dart';

GroupDetailModel groupDetailModelFromJson(String str) => GroupDetailModel.fromJson(json.decode(str));

String groupDetailModelToJson(GroupDetailModel data) => json.encode(data.toJson());

class GroupDetailModel {
  GroupDetailModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  GroupDetail data;

  factory GroupDetailModel.fromJson(Map<String, dynamic> json) =>
      GroupDetailModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: GroupDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "succeeded": succeeded,
    "message": message,
    "data": data.toJson(),
  };
}
