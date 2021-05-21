import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info_model.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';

class UpdateProfileForm {
  UpdateProfileForm({
    this.fullName,
    this.dob,
    this.phoneNumber,
    this.address,
  });

  String fullName;
  DateTime dob;
  String phoneNumber;
  AddressModel address;

  factory UpdateProfileForm.fromJson(Map<String, dynamic> json) =>
      UpdateProfileForm(
        fullName: json["fullName"],
        dob: DateTime.parse(json["dob"]),
        phoneNumber: json["phoneNumber"],
        address: AddressModel.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "dob":
            dob != null ? dob.toIso8601String() : DateTime(1).toIso8601String(),
        "phoneNumber": phoneNumber,
        "address": address?.toJson(),
      };
}

class UserServices {
  static Future<void> getUserInfo() async {
    Uri url = Uri.https(APIService.apiUrl, "/User");
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    if (response.statusCode == 200) {
      AccessInfo().userInfo =
          UserInfoModel.fromJson(jsonDecode(response.body)).data;
    }
  }

  static Future<UserInfo> getUserInfoById(int userId) async {
    Uri url = Uri.https(APIService.apiUrl, "/User/$userId");
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    if (response.statusCode == 200) {
      return UserInfoModel.fromJson(jsonDecode(response.body)).data;
    } else {
      return null;
    }
  }

  static Future<UserInfo> updateUserInfo(UpdateProfileForm form) async {
    Uri url = Uri.https(APIService.apiUrl, "/User");
    var response = await http.put(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        },
        body: jsonEncode(form.toJson()));
    print(response.body);
    if (response.statusCode == 200)
      return UserInfoModel.fromJson(jsonDecode(response.body)).data;
    else
      return null;
  }
}
