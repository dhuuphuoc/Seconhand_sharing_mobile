import 'package:secondhand_sharing/models/enums/request_status/request_status.dart';

class ReceiveRequest {
  ReceiveRequest(
      {this.id,
      this.receiveReason,
      this.receiverId,
      this.receiverName,
      this.requestStatus,
      this.itemId,
      this.itemName,
      this.createDate,
      this.receiverAvatarUrl});

  int id;
  String receiveReason;
  int receiverId;
  String receiverName;
  String receiverAvatarUrl;
  RequestStatus requestStatus;
  int itemId;
  String itemName;
  DateTime createDate;

  factory ReceiveRequest.fromJson(Map<String, dynamic> json) => ReceiveRequest(
        id: json["id"],
        receiveReason: json["receiveReason"],
        receiverId: json["receiverId"],
        receiverName: json["receiverName"],
        requestStatus: RequestStatus.values[json["receiveStatus"] == null ? 0 : json["receiveStatus"]],
        itemId: json["itemId"],
        itemName: json["itemName"],
        createDate: DateTime.parse(json["createDate"]),
        receiverAvatarUrl: json["receiverAvatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "receiveReason": receiveReason,
        "receiverId": receiverId,
        "receiverName": receiverName,
        "itemId": itemId,
        "itemName": itemName,
      };
}
