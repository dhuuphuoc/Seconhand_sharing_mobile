import 'dart:io';

import 'package:secondhand_sharing/models/notification/notification.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';

import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

class UserNotificationServices {
  static Future<List<UserNotification>> getNotifications(int pageNumber, int pageSize) async {
    Uri url = Uri.https(
        APIService.apiUrl, "/Notification", {"PageNumber": pageNumber.toString(), "PageSize": pageSize.toString()});
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.body);
    return List<UserNotification>.from(
        ResponseDeserializer.deserializeResponseToList(response).map((x) => UserNotification.fromJson(x)));
  }
}
