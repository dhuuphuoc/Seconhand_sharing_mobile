import 'dart:convert';

import 'package:secondhand_sharing/models/address_model/address_model.dart';

class UserInfo {
  UserInfo(
      {this.id,
      this.fullName,
      this.dob,
      this.phoneNumber,
      this.avatar,
      this.address,
      this.email});

  int id;
  String fullName;
  DateTime dob;
  String phoneNumber;
  String avatar;
  String email;
  AddressModel address;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        fullName: json["fullName"],
        dob: DateTime.parse(json["dob"]),
        phoneNumber: json["phoneNumber"],
        avatar: json["avatar"],
        address: json["address"] == null
            ? AddressModel()
            : AddressModel.fromJson(json["address"]),
        email: json["email"],
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
