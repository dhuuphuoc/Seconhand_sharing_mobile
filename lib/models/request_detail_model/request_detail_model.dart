import 'package:secondhand_sharing/models/request_detail_model/request_detail.dart';

class RequestDetailModel {
  RequestDetailModel({
    this.succeeded,
    this.message,
    this.requestDetail,
  });

  bool succeeded;
  dynamic message;
  RequestDetail requestDetail;

  factory RequestDetailModel.fromJson(Map<String, dynamic> json) =>
      RequestDetailModel(
        succeeded: json["succeeded"],
        message: json["message"],
        requestDetail: RequestDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": requestDetail.toJson(),
      };
}
