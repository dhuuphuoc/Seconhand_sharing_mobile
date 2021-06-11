import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:secondhand_sharing/models/group_model/create_group/create_group.dart';
import 'package:secondhand_sharing/models/group_model/create_group/create_group_model.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/group_model/group/group_model.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;

class GroupServices {
  static Future<CreateGroupModel> createGroup(
      CreateGroupForm createGroupForm) async {
    Uri createGroupUrl = Uri.https(APIService.apiUrl, "/group");
    var response = await http.post(createGroupUrl,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        },
        body: jsonEncode(createGroupForm.toJson()));
    print(response.body);

    if (response.statusCode == 200) {
      return CreateGroupModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<List<Group>> getGroups(int id) async {
    Uri url = Uri.https(APIService.apiUrl, "/group/$id");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    if (response.statusCode == 200) {
      return GroupModel.fromJson(jsonDecode(response.body)).items;
    } else {
      return null;
    }
  }

  static Future<GroupDetail> getGroupDetail(int id) async {
    Uri url = Uri.https(APIService.apiUrl, "Group/$id");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
    });
    print(response.body);
    if (response.statusCode == 200) {
      return GroupDetailModel.fromJson(jsonDecode(response.body)).data;
    } else {
      return null;
    }
  }
}
