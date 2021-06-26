import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/enums/member_role/member_role.dart';
import 'package:secondhand_sharing/models/group_model/create_group/create_group.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/models/member/member.dart';
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
    if (response.statusCode == 200)
      return Group.fromJson(jsonDecode(response.body)["data"]);
    else
      return null;
  }

  static Future<MemberRole> getMemberRole(int userId, int groupId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/get-role", {"userId": userId.toString()});
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    if (response.statusCode == 200) {
      String role = jsonDecode(response.body)["message"];
      if (role == "admin")
        return MemberRole.admin;
      else
        return MemberRole.member;
    } else
      return null;
  }

  static Future<List<Group>> getGroups() async {
    Uri url = Uri.https(APIService.apiUrl, "/Group");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<Group>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Group.fromJson(x)));
  }

  static Future<List<Group>> getJoinedGroups() async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/joined-group");
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
    if (response.statusCode == 200)
      return GroupDetail.fromJson(jsonDecode(response.body)["data"]);
    else
      return null;
  }

  static Future<List<Member>> getMembers(int groupId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/member");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<Member>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Member.fromJson(x)));
  }

  static Future<List<Member>> getAdmins(int groupId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/admin");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<Member>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Member.fromJson(x)));
  }

  static Future<int> inviteMember(int groupId, String email) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/member");
    var response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        },
        body: jsonEncode({"email": email}));
    print(response.body);
    if (response.statusCode == 200) return 0;
    String message = jsonDecode(response.body)["Message"];

    if (message == "Member exist in group.") {
      return 1;
    }
    if (message == "Email does not exist.") {
      return 2;
    }
    return 3;
  }

  static Future<bool> kickMember(int groupId, int memberId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/member/$memberId");
    var response = await http.delete(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      },
    );
    print(response.body);
    return response.statusCode == 200;
  }
}
