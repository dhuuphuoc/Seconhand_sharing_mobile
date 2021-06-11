import 'dart:convert';

AddGroupMemberModel addGroupMemberModelFromJson(String str) =>
    AddGroupMemberModel.fromJson(json.decode(str));

String addGroupMemberModelToJson(AddGroupMemberModel data) =>
    json.encode(data.toJson());

class AddGroupMemberModel {
  AddGroupMemberModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  MemberGroupData data;

  factory AddGroupMemberModel.fromJson(Map<String, dynamic> json) =>
      AddGroupMemberModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: MemberGroupData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "succeeded": succeeded,
    "message": message,
    "data": data.toJson(),
  };
}

class MemberGroupData {
  MemberGroupData({
    this.id,
    this.memberId,
    this.groupId,
    this.reportStatus,
    this.joinDate,
  });

  int id;
  int memberId;
  int groupId;
  int reportStatus;
  DateTime joinDate;

  factory MemberGroupData.fromJson(Map<String, dynamic> json) =>
      MemberGroupData(
        id: json["id"],
        memberId: json["memberId"],
        groupId: json["groupId"],
        reportStatus: json["reportStatus"],
        joinDate: DateTime.parse(json["joinDate"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "memberId": memberId,
    "groupId": groupId,
    "reportStatus": reportStatus,
    "joinDate": joinDate.toIso8601String(),
  };
}
