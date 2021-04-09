import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/models/item_model/item_model.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/user_singleton/user_singleton.dart';

class ItemServices {
  static final int _pageSize = 5;

  static Future<List<Item>> getItems(int pageNumber) async {
    Uri getItemsUrl = Uri.https(APIService.apiUrl, "/Item", {
      "PageNumber": pageNumber.toString(),
      "PageSize": _pageSize.toString()
    });
    var response = await http.get(getItemsUrl, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${UserSingleton().token}",
      HttpHeaders.contentTypeHeader: "application/json",
    });
    var itemModel = ItemModel.fromJson(jsonDecode(response.body));
    return itemModel.items;
  }

  static void postItem() {}
}
