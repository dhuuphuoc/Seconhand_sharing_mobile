class CancelRequestModel {
  CancelRequestModel({
    this.requestId,
    this.itemId,
  });

  int requestId;
  int itemId;

  factory CancelRequestModel.fromJson(Map<String, dynamic> json) => CancelRequestModel(
        requestId: json["requestId"],
        itemId: json["itemId"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "itemId": itemId,
      };
}
