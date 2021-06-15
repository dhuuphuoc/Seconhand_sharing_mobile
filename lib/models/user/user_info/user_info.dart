import 'package:secondhand_sharing/models/address_model/address_model.dart';

class UserInfo {
  UserInfo({
    this.id,
    this.fullName,
    this.dob,
    this.phoneNumber,
    this.address,
    this.email,
    this.avatarUrl,
  });

  int id;
  String fullName;
  DateTime dob;
  String phoneNumber;
  String email;
  AddressModel address;
  String avatarUrl;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        fullName: json["fullName"],
        dob: DateTime.parse(json["dob"]),
        phoneNumber: json["phoneNumber"],
        address: json["address"] == null ? AddressModel() : AddressModel.fromJson(json["address"]),
        email: json["email"],
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "dob": dob.toIso8601String(),
        "phoneNumber": phoneNumber,
        "address": address.toJson(),
      };
}
