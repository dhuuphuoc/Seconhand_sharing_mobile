import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/enums/item_status/item_status.dart';

class Item {
  Item({
    this.id,
    this.itemName,
    this.receiveAddress,
    this.postTime,
    this.description,
    this.imageUrl,
    this.donateAccountId,
    this.donateAccountName,
    this.avatarUrl,
    this.eventName,
    this.eventId,
    this.status,
  });

  int id;
  String itemName;
  AddressModel receiveAddress;
  DateTime postTime;
  String description;
  String imageUrl;
  int donateAccountId;
  String donateAccountName;
  String avatarUrl;
  int eventId;
  String eventName;
  ItemStatus status;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        itemName: json["itemName"],
        receiveAddress: AddressModel.fromJson(json["address"]),
        postTime: DateTime.parse(json["postTime"]),
        description: json["description"],
        imageUrl: json["imageUrl"],
        donateAccountName: json["donateAccountName"],
        donateAccountId: json["donateAccountId"],
        avatarUrl: json["avatarUrl"],
        eventId: json["eventId"],
        eventName: json["eventName"],
        status: ItemStatus.values[json["status"] ?? 0],
      );

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
