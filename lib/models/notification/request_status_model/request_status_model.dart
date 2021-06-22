import 'package:secondhand_sharing/models/enums/request_status/request_status.dart';

class RequestStatusModel {
  RequestStatusModel({
    this.requestId,
    this.itemId,
    this.itemName,
    this.requestStatus,
  });

  int requestId;
  String itemName;
  int itemId;
  RequestStatus requestStatus;

  factory RequestStatusModel.fromJson(Map<String, dynamic> json) => RequestStatusModel(
        requestId: json["requestId"],
        itemId: json["itemId"],
        itemName: json["itemName"],
        requestStatus: RequestStatus.values[json["requestStatus"]],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "itemId": itemId,
        "itemName": itemName,
        "requestStatus": requestStatus.index,
      };
}
