import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';

class ReceiveRequest {
  ReceiveRequest(
      {this.id,
      this.receiveReason,
      this.receiverId,
      this.receiverName,
      this.requestStatus});

  int id;
  String receiveReason;
  int receiverId;
  String receiverName;
  RequestStatus requestStatus;
  int itemId;

  factory ReceiveRequest.fromJson(Map<String, dynamic> json) => ReceiveRequest(
        id: json["id"],
        receiveReason: json["receiveReason"],
        receiverId: json["receiverId"],
        receiverName: json["receiverName"],
        requestStatus: RequestStatus.values[json["receiveStatus"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "receiveReason": receiveReason,
        "receiverId": receiverId,
        "receiverName": receiverName,
      };
}
