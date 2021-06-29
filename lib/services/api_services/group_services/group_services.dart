import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/add_member_model/add_member_model.dart';
import 'package:secondhand_sharing/models/enums/add_member_response_type/add_member_response_type.dart';
import 'package:secondhand_sharing/models/enums/join_status/join_status.dart';
import 'package:secondhand_sharing/models/enums/member_role/member_role.dart';
import 'package:secondhand_sharing/models/group_model/create_group/create_group.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/models/image_upload_model/image_upload_model.dart';
import 'package:secondhand_sharing/models/invitation/invitation.dart';
import 'package:secondhand_sharing/models/join_request/join_request.dart';
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
    print(response.body);
    if (response.statusCode == 200) {
      String role = jsonDecode(response.body)["message"];
      if (role == "admin") return MemberRole.admin;
      if (role == "member") return MemberRole.member;
    }
    return null;
  }

  static Future<JoinStatus> getJoinStatus(int groupId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/join-status");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return JoinStatus.values[jsonDecode(response.body)["data"]];
    }
    return JoinStatus.none;
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

  static Future<List<JoinRequest>> getJoinRequests(int groupId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/request-join");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<JoinRequest>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => JoinRequest.fromJson(x)));
  }

  static Future<List<Invitation>> getInvitations() async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/invitations");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<Invitation>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Invitation.fromJson(x)));
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

  static Future<bool> appointAdmin(int groupId, memberId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/appoint-admin/$memberId");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<String> updateAvatar(int groupId, ImageData image) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/update-avatar");
    var response = await http.put(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );
    print(response.body);

    ImageUploadModel imageUploadModel = ImageUploadModel.fromJson(jsonDecode(response.body)["data"]);
    var result = await APIService.uploadImage(image, imageUploadModel.imageUpload.presignUrl);
    if (result) {
      return APIService.cloudUrl + imageUploadModel.imageUpload.imageName;
    } else {
      return null;
    }
  }

  static Future<bool> demoteAdmin(int groupId, memberId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/demote-admin/$memberId");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> acceptJoinRequest(int groupId, memberId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/join-request/$memberId/accept");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> rejectJoinRequest(int groupId, memberId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/join-request/$memberId/reject");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> acceptInvitation(int groupId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/accept-invitation");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> declineInvitation(int groupId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/decline-invitation");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<AddMemberModel> inviteMember(int groupId, String email) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/member");
    var response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        },
        body: jsonEncode({"email": email}));
    print(response.body);
    var json = jsonDecode(response.body);
    var result = AddMemberModel();
    if (response.statusCode == 200) {
      result.member = Member.fromJson(json["data"]);
      if (json["message"] == "Added") {
        result.type = AddMemberResponseType.added;
      }
      if (json["message"] == "Invited") {
        result.type = AddMemberResponseType.invited;
      }
      return result;
    }
    String message = json["Message"];

    if (message == "Member exist in group.") {
      result.type = AddMemberResponseType.existed;
    }
    if (message == "Email does not exist.") {
      result.type = AddMemberResponseType.notExist;
    }
    result.type = AddMemberResponseType.notAdmin;
    return result;
  }

  static Future<bool> joinGroup(int groupId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Group/$groupId/join");
    var response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      },
    );
    print(response.body);
    return response.statusCode == 200;
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
