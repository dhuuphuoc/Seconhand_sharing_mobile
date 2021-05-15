import 'dart:convert';

import 'package:secondhand_sharing/models/address_model/address_model.dart';

class UserInfo {
  UserInfo({
    this.id,
    this.fullName,
    this.dob,
    this.phoneNumber,
    this.avatar,
    this.address,
  });

  String id;
  String fullName;
  DateTime dob;
  String phoneNumber;
  String avatar;
  AddressModel address;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        fullName: json["fullName"],
        dob: DateTime.parse(json["dob"]),
        phoneNumber: json["phoneNumber"],
        avatar: json["avatar"],
        address: AddressModel.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "dob": dob.toIso8601String(),
        "phoneNumber": phoneNumber,
        "avatar": avatar,
        "address": address.toJson(),
      };
}
