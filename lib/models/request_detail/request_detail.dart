import 'package:secondhand_sharing/models/enums/request_status/request_status.dart';

class RequestDetail {
  RequestDetail({
    this.id,
    this.receiveReason,
    this.receiveStatus,
  });

  int id;
  String receiveReason;
  RequestStatus receiveStatus;

  factory RequestDetail.fromJson(Map<String, dynamic> json) => RequestDetail(
        id: json["id"],
        receiveReason: json["receiveReason"],
        receiveStatus: RequestStatus.values[json["receiveStatus"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "receiveReason": receiveReason,
        "receiveStatus": receiveStatus,
      };
}
