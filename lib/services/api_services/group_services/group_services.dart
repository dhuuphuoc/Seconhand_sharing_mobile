import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/group_model/create_group/create_group.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

class GroupServices {
  static Future<Group> createGroup(CreateGroupForm createGroupForm) async {
    Uri createGroupUrl = Uri.https(APIService.apiUrl, "/group");
    var response = await http.post(createGroupUrl,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        },
        body: jsonEncode(createGroupForm.toJson()));
    print(response.body);
    return Group.fromJson(ResponseDeserializer.deserializeResponse(response));
  }

  static Future<List<Group>> getGroups(int id) async {
    Uri url = Uri.https(APIService.apiUrl, "/group/$id");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<Group>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Group.fromJson(x)));
  }

  static Future<GroupDetail> getGroupDetail(int id) async {
    Uri url = Uri.https(APIService.apiUrl, "Group/$id");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
    });
    print(response.body);
    return GroupDetail.fromJson(ResponseDeserializer.deserializeResponse(response));
  }
}
