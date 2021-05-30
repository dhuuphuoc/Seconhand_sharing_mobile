import 'package:secondhand_sharing/models/notification_model/notification.dart';

class NotificationsModel {
  NotificationsModel({
    this.pageNumber,
    this.pageSize,
    this.succeeded,
    this.message,
    this.data,
  });

  int pageNumber;
  int pageSize;
  bool succeeded;
  String message;
  List<UserNotification> data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        succeeded: json["succeeded"],
        message: json["message"],
        data: List<UserNotification>.from(json["data"].map((x) => UserNotification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "succeeded": succeeded,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
