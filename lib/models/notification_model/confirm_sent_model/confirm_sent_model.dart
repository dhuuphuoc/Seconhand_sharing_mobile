class ConfirmSentModel {
  ConfirmSentModel({this.itemId, this.itemName, this.receiverId, this.receiverName});

  int itemId;
  String itemName;
  int receiverId;
  String receiverName;

  factory ConfirmSentModel.fromJson(Map<String, dynamic> json) => ConfirmSentModel(
        itemId: json["itemId"],
        itemName: json["itemName"],
        receiverId: json["receiverId"],
        receiverName: json["receiverName"],
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "itemName": itemName,
        "receiverId": receiverId,
        "receiverName": receiverName,
      };
}
