import 'package:secondhand_sharing/models/address_model/address_model.dart';

class Item {
  Item(
      {this.id,
      this.itemName,
      this.receiveAddress,
      this.postTime,
      this.description,
      this.imageUrl,
      this.donateAccountName});

  int id;
  String itemName;
  AddressModel receiveAddress;
  DateTime postTime;
  String description;
  String imageUrl;
  String donateAccountName;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json["id"],
      itemName: json["itemName"],
      receiveAddress: AddressModel.fromJson(json["address"]),
      postTime: DateTime.parse(json["postTime"]),
      description: json["description"],
      imageUrl: json["imageUrl"],
      donateAccountName: json["donateAccountName"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "receiveAddress": receiveAddress,
        "postTime": postTime.toIso8601String(),
        "description": description,
        "imageUrl": imageUrl,
        "donateAccountName": donateAccountName
      };
}
