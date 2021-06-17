import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/item/item.dart';
import 'package:secondhand_sharing/models/receive_request/receive_request.dart';
import 'package:secondhand_sharing/models/request_detail/request_detail.dart';

import 'package:secondhand_sharing/models/user/access_info/access_info.dart';

import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

class ReceiveServices {
  static Future<int> registerToReceive(int itemId, String message) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem");
    var response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
        },
        body: jsonEncode({"itemId": itemId, "receiveReason": message}));
    print(response.body);
    return ResponseDeserializer.deserializeResponseToInt(response);
  }

  static Future<List<Item>> getRequestedItems(int userId, int pageNumber, int pageSize) async {
    Uri getItemsUrl = Uri.https(APIService.apiUrl, "/ReceiveItem/$userId/requests", {
      "PageNumber": pageNumber.toString(),
      "PageSize": pageSize.toString(),
    });
    print(getItemsUrl);

    var response = await http.get(getItemsUrl, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.body);
    return List<Item>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Item.fromJson(x)));
  }

  static Future<bool> cancelRegistration(int requestId) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId/cancel-receive");
    var response = await http.put(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
      },
    );
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<RequestDetail> getRequestDetail(int requestId) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId");
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
      },
    );
    print(response.body);
    return RequestDetail.fromJson(ResponseDeserializer.deserializeResponse(response));
  }

  static Future<List<ReceiveRequest>> getItemRequests(int itemId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Item/$itemId/receive-request");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
    });
    print(response.body);
    return List<ReceiveRequest>.from(
        ResponseDeserializer.deserializeResponseToList(response).map((x) => ReceiveRequest.fromJson(x)));
  }

  static Future<bool> acceptRequest(int requestId) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId/accept");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
    });
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> cancelReceiver(int requestId) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId/cancel-receiver");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
    });
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> sendThanks(int requestId, String message) async {
    Uri url = Uri.https(APIService.apiUrl, "/ReceiveItem/$requestId/send-thanks");
    var response = await http.put(url,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}"
        },
        body: jsonEncode({"thanks": message}));
    print(response.body);
    return response.statusCode == 200;
  }
}
