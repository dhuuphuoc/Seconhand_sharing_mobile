import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/group_event/group_event.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/models/image_upload_model/images_upload_model.dart';
import 'package:secondhand_sharing/models/item/item.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

class EventForm {
  EventForm({
    this.eventName,
    this.startDate,
    this.endDate,
    this.content,
    this.groupId,
  });

  String eventName;
  DateTime startDate;
  DateTime endDate;
  String content;
  int groupId;

  factory EventForm.fromJson(Map<String, dynamic> json) => EventForm(
        eventName: json["eventName"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        content: json["content"],
        groupId: json["groupId"],
      );

  Map<String, dynamic> toJson() => {
        "eventName": eventName,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "content": content,
        "groupId": groupId,
      };
}

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

  static Future<ImagesUploadModel> postItem(int eventId, PostItemForm postItemForm) async {
    Uri postItemsUrl = Uri.https(APIService.apiUrl, "/Event/$eventId/item");
    var response = await http.post(postItemsUrl,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        },
        body: jsonEncode(postItemForm.toJson()));
    print(response.body);
    if (response.statusCode == 200)
      return ImagesUploadModel.fromJson(jsonDecode(response.body)["data"]);
    else
      return null;
  }

  static Future<GroupEvent> createEvent(EventForm eventForm) async {
    Uri url = Uri.https(APIService.apiUrl, "/Event");
    var response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        },
        body: jsonEncode(eventForm.toJson()));
    print(response.body);
    if (response.statusCode == 200)
      return GroupEvent.fromJson(jsonDecode(response.body)["data"]);
    else
      return null;
  }

  static Future<List<Item>> getItems(int eventId, int pageNumber, int pageSize) async {
    Uri url = Uri.https(APIService.apiUrl, "/Event/$eventId/item", {
      "PageNumber": pageNumber.toString(),
      "PageSize": pageSize.toString(),
    });
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<Item>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Item.fromJson(x)));
  }

  static Future<List<Item>> getMyDonations(int eventId, int pageNumber, int pageSize) async {
    Uri url = Uri.https(APIService.apiUrl, "/Event/$eventId/my-donations", {
      "PageNumber": pageNumber.toString(),
      "PageSize": pageSize.toString(),
    });
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<Item>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Item.fromJson(x)));
  }

  static Future<GroupEvent> getEventDetail(int eventId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Event/$eventId");
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );
    print(response.body);
    if (response.statusCode == 200)
      return GroupEvent.fromJson(jsonDecode(response.body)["data"]);
    else
      return null;
  }

  static Future<bool> acceptItem(int eventId, int itemId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Event/$eventId/accept-item/$itemId");
    var response = await http.put(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> cancelAccept(int eventId, int itemId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Event/$eventId/cancel-accept/$itemId");
    var response = await http.put(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> rejectItem(int eventId, int itemId) async {
    Uri url = Uri.https(APIService.apiUrl, "/Event/$eventId/reject-item/$itemId");
    var response = await http.delete(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );
    print(response.body);
    return response.statusCode == 200;
  }
}
