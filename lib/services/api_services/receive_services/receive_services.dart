import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/request_detail_model/request_detail.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_detail_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;

class ReceiveServices {
  static Future<bool> registerToReceive(int itemId, String message) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem");
    var response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
        },
        body: jsonEncode({"itemId": itemId, "reason": message}));
    print(response.body);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<bool> cancelRegistration(int requestId) async {
    Uri url =
        Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId/cancel-receive");
    var response = await http.put(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<RequestDetail> getRequestDetail(int requestId) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId");
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
      },
    );
    print(response.body);
    if (response.statusCode == 200)
      return RequestDetailModel.fromJson(jsonDecode(response.body))
          .requestDetail;
    else
      return null;
  }
}
