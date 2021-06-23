import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/message/user_message.dart';

import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

class MessageServices {
  static Future<List<UserMessage>> getMessages(int userId, int pageNumber, int pageSize) async {
    Uri url = Uri.https(APIService.apiUrl, "/Message/$userId", {
      "PageNumber": pageNumber.toString(),
      "PageSize": pageSize.toString(),
    });
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.body);
    return List<UserMessage>.from(
        ResponseDeserializer.deserializeResponseToList(response).map((x) => UserMessage.fromJson(x)));
  }

  static Future<List<UserMessage>> getRecentMessages(int pageNumber, int pageSize) async {
    Uri url = Uri.https(APIService.apiUrl, "/Message/recent-messages", {
      "PageNumber": pageNumber.toString(),
      "PageSize": pageSize.toString(),
    });
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.body);
    return List<UserMessage>.from(
        ResponseDeserializer.deserializeResponseToList(response).map((x) => UserMessage.fromJson(x)));
  }

  static Future<UserMessage> sendMessage(UserMessage message) async {
    Uri url = Uri.https(APIService.apiUrl, "/Message");
    var response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(message.toJson()),
    );
    print(response.body);
    if (response.statusCode == 200)
      return UserMessage.fromJson(jsonDecode(response.body)["data"]);
    else
      return null;
  }
}
