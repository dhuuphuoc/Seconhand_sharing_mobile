import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/notification_model/notification.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/notification_model/notifications_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';

class UserNotificationServices {
  static int _pageSize = 10;

  static Future<List<UserNotification>> getNotifications(int pageNumber) async {
    Uri url = Uri.https(
        APIService.apiUrl, "/Notification", {"PageNumber": pageNumber.toString(), "PageSize": _pageSize.toString()});
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.body);
    if (response.statusCode == 200) {
      return NotificationsModel.fromJson(jsonDecode(response.body)).data;
    } else
      return [];
  }
}
