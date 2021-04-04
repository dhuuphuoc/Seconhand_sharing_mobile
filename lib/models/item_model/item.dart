class Item {
  Item({
    this.id,
    this.itemName,
    this.receiveAddress,
    this.postTime,
    this.description,
    this.imageUrl,
  });

  int id;
  String itemName;
  String receiveAddress;
  DateTime postTime;
  String description;
  String imageUrl;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        itemName: json["itemName"],
        receiveAddress: json["receiveAddress"],
        postTime: DateTime.parse(json["postTime"]),
        description: json["description"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "receiveAddress": receiveAddress,
        "postTime": postTime.toIso8601String(),
        "description": description,
        "imageUrl": imageUrl,
      };
}
