import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/receive_request_model/receive_request_model.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_requests_model.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_detail.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_detail_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;

class ReceiveServices {
  static Future<int> registerToReceive(int itemId, String message) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem");
    var response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
        },
        body: jsonEncode({"itemId": itemId, "receiveReason": message}));
    print(response.body);
    if (response.statusCode == 200) {
      return ReceiveRequestModel.fromJson(jsonDecode(response.body)).data;
    } else {
      return 0;
    }
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
    print(response.body);
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

  static Future<List<ReceiveRequest>> getItemRequests(int itemId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Item/$itemId/receive-request");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
    });
    print(response.body);
    if (response.statusCode == 200) {
      return ReceiveRequestsModel.fromJson(jsonDecode(response.body)).requests;
    } else {
      return null;
    }
  }

  static Future<bool> acceptRequest(int requestId) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId/accept");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
    });
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> cancelReceiver(int requestId) async {
    Uri url =
        Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId/cancel-receiver");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
    });
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> sendThanks(int requestId, String message) async {
    Uri url =
        Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId/send-thanks");
    var response = await http.put(url,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
        },
        body: jsonEncode({"thanks": message}));
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
