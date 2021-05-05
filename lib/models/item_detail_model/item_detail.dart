import 'package:secondhand_sharing/models/address_model/address_model.dart';

class ItemDetail {
  ItemDetail({
    this.id,
    this.itemName,
    this.receiveAddress,
    this.postTime,
    this.description,
    this.imageUrl,
    this.donateAccountName,
  });

  int id;
  String itemName;
  AddressModel receiveAddress;
  DateTime postTime;
  String description;
  List<String> imageUrl;
  String donateAccountName;

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        id: json["id"],
        itemName: json["itemName"],
        receiveAddress: AddressModel.fromJson(json["receiveAddress"]),
        postTime: DateTime.parse(json["postTime"]),
        description: json["description"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        donateAccountName: json["donateAccountName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "receiveAddress": receiveAddress.toJson(),
        "postTime": postTime.toIso8601String(),
        "description": description,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "donateAccountName": donateAccountName,
      };
}
