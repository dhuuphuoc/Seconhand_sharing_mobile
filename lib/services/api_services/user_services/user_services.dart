import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/models/image_upload_model/image_upload_model.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user/user_info/user_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

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

  factory UpdateProfileForm.fromJson(Map<String, dynamic> json) => UpdateProfileForm(
        fullName: json["fullName"],
        dob: DateTime.parse(json["dob"]),
        phoneNumber: json["phoneNumber"],
        address: AddressModel.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "dob": dob != null ? dob.toIso8601String() : DateTime(1).toIso8601String(),
        "phoneNumber": phoneNumber,
        "address": address?.toJson(),
      };
}

class UserServices {
  static Future<bool> getUserInfo() async {
    Uri url = Uri.https(APIService.apiUrl, "/User");
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.body);
    UserInfo userInfo = UserInfo.fromJson(ResponseDeserializer.deserializeResponse(response));
    if (userInfo != null) {
      AccessInfo().userInfo = userInfo;
      return true;
    }
    return false;
  }

  static Future<String> uploadAvatar(ImageData image) async {
    Uri url = Uri.https(APIService.apiUrl, "/User/update-avatar");
    var response = await http.put(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );
    print(response.body);
    ImageUploadModel imageUploadModel = ImageUploadModel.fromJson(ResponseDeserializer.deserializeResponse(response));
    var result = await APIService.uploadImage(image, imageUploadModel.imageUpload.presignUrl);
    if (result) {
      return APIService.cloudUrl + imageUploadModel.imageUpload.imageName;
    } else {
      return null;
    }
  }

  static Future<UserInfo> getUserInfoById(int userId) async {
    Uri url = Uri.https(APIService.apiUrl, "/User/$userId");
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.body);
    return UserInfo.fromJson(ResponseDeserializer.deserializeResponse(response));
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
    return UserInfo.fromJson(ResponseDeserializer.deserializeResponse(response));
  }
}
