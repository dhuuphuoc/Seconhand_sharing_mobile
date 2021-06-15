import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/enums/item_status/item_status.dart';

class ItemDetail {
  ItemDetail(
      {this.id,
      this.itemName,
      this.receiveAddress,
      this.postTime,
      this.description,
      this.imageUrl,
      this.donateAccountId,
      this.donateAccountName,
      this.userRequestId,
      this.status,
      this.avatarUrl});

  int id;
  String itemName;
  AddressModel receiveAddress;
  DateTime postTime;
  String description;
  List<String> imageUrl;
  int donateAccountId;
  String donateAccountName;
  int userRequestId;
  ItemStatus status;
  String avatarUrl;

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        id: json["id"],
        itemName: json["itemName"],
        receiveAddress: AddressModel.fromJson(json["receiveAddress"]),
        postTime: DateTime.parse(json["postTime"]),
        description: json["description"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        donateAccountId: json["donateAccountId"],
        donateAccountName: json["donateAccountName"],
        userRequestId: json["userRequestId"],
        status: ItemStatus.values[json["status"]],
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "receiveAddress": receiveAddress.toJson(),
        "postTime": postTime.toIso8601String(),
        "description": description,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "donateAccountName": donateAccountName,
        "donateAccountId": donateAccountId,
        "userRequestId": userRequestId
      };
}
