import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/models/item_model/item_model.dart';
import 'package:secondhand_sharing/models/item_model/post_item_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;

class PostItemForm {
  PostItemForm({
    this.itemName,
    this.receiveAddress,
    this.categoryId,
    this.description,
    this.imageNumber,
  });

  String itemName;
  AddressModel receiveAddress;
  int categoryId;
  String description;
  int imageNumber;

  factory PostItemForm.fromJson(Map<String, dynamic> json) => PostItemForm(
        itemName: json["itemName"],
        receiveAddress: json["receiveAddress"],
        categoryId: json["categoryId"],
        description: json["description"],
        imageNumber: json["imageNumber"],
      );

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "receiveAddress": receiveAddress.toJson(),
        "categoryId": categoryId,
        "description": description,
        "imageNumber": imageNumber,
      };
}

class ItemServices {
  static final int _pageSize = 5;

  static Future<List<Item>> getItems(int pageNumber) async {
    Uri getItemsUrl = Uri.https(APIService.apiUrl, "/Item", {
      "PageNumber": pageNumber.toString(),
      "PageSize": _pageSize.toString()
    });
    var response = await http.get(getItemsUrl, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
      HttpHeaders.contentTypeHeader: "application/json",
    });
    print(response.body);
    if (response.statusCode == 200) {
      return ItemModel.fromJson(jsonDecode(response.body)).items;
    }
    return null;
  }

  static Future<int> uploadImage(ImageData image, String url) async {
    Uri uploadUrl = Uri.parse(url);
    print(uploadUrl.toString());
    var response = await http.put(uploadUrl,
        body: image.data,
        headers: {HttpHeaders.contentTypeHeader: "image/png"});
    print(response.body);
    return response.statusCode;
  }

  static Future<PostItemModel> postItem(PostItemForm postItemForm) async {
    Uri postItemsUrl = Uri.https(APIService.apiUrl, "/Item");
    var response = await http.post(postItemsUrl,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(postItemForm.toJson()));
    print(postItemForm.toJson());
    print(response.body);
    if (response.statusCode == 200) {
      return PostItemModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
