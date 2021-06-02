import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'package:secondhand_sharing/models/messages_model/messages_model.dart';
import 'package:secondhand_sharing/models/messages_model/send_message_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';

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
    if (response.statusCode == 200) {
      return MessagesModel.fromJson(jsonDecode(response.body)).messages;
    } else {
      return [];
    }
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
    if (response.statusCode == 200) {
      return MessagesModel.fromJson(jsonDecode(response.body)).messages;
    } else {
      return [];
    }
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
    if (response.statusCode == 200) {
      return SendMessageModel.fromJson(jsonDecode(response.body)).data;
    } else {
      return null;
    }
  }
}
