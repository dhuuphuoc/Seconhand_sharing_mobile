import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info_model.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';

class UserServices {
  static Future<UserInfo> getUserInfo() async {
    Uri url = Uri.https(APIService.apiUrl, "/User");
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: "application/json",
    });
    return UserInfoModel.fromJson(jsonDecode(response.body)).data;
  }
}
