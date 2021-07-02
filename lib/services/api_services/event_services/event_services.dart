import 'dart:io';

import 'package:secondhand_sharing/models/group_event/group_event.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

class EventServices {
  static Future<List<GroupEvent>> getEvents(int pageNumber, int pageSize) async {
    Uri url = Uri.https(
        APIService.apiUrl,
        "/Event",
        pageSize != null && pageNumber != null
            ? {
                "PageNumber": pageNumber.toString(),
                "PageSize": pageSize.toString(),
              }
            : null);
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<GroupEvent>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => GroupEvent.fromJson(x)));
  }
}
