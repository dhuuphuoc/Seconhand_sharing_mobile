import 'package:secondhand_sharing/models/address_model/address_model.dart';

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
      this.userRequestId});

  int id;
  String itemName;
  AddressModel receiveAddress;
  DateTime postTime;
  String description;
  List<String> imageUrl;
  int donateAccountId;
  String donateAccountName;
  int userRequestId;

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
