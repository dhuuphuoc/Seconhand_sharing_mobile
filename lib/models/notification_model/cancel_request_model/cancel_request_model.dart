class CancelRequestModel {
  CancelRequestModel({
    this.requestId,
    this.itemId,
    this.itemName,
  });

  int requestId;
  int itemId;
  String itemName;

  factory CancelRequestModel.fromJson(Map<String, dynamic> json) => CancelRequestModel(
        requestId: json["requestId"],
        itemId: json["itemId"],
        itemName: json["itemName"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "itemId": itemId,
      };
}
