import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/models/item_model/item_model.dart';
import 'package:secondhand_sharing/models/item_model/post_item_model.dart';
import 'package:secondhand_sharing/models/user_model/user_singleton/access_token.dart';
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
  String receiveAddress;
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
        "receiveAddress": receiveAddress,
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
    var itemModel = ItemModel.fromJson(jsonDecode(response.body));
    return itemModel.items;
  }

  static Future<PostItemModel> postItem(PostItemForm postItemForm) async {
    Uri postItemsUrl = Uri.https(APIService.apiUrl, "/Item");
    var response = await http.post(postItemsUrl,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(postItemForm.toJson()));
    print(response.body);
    return PostItemModel.fromJson(jsonDecode(response.body));
  }
}
