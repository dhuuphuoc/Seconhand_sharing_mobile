import 'dart:convert';

import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/models/item_model/item_model.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;

class ItemServices {
  static final int _pageSize = 5;

  static Future<List<Item>> getItems(int pageNumber) async {
    Uri getItemsUrl = Uri.https(APIService.apiUrl, "/Item", {
      "PageNumber": pageNumber.toString(),
      "PageSize": _pageSize.toString()
    });
    var response = await http.get(getItemsUrl, headers: {
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkYWYwNDAzZC0yNTMyLTQ2OGUtYTlmYi0yOWIxM2I2MzQyZTIiLCJ1c2VyaWQiOiIxMSIsInVzZXJuYW1lIjoibWVva2c0NTYiLCJleHAiOjE2MjEwNDE4NDgsImlzcyI6IjJIYW5kc2hhcmluZ0lkZW50aXR5IiwiYXVkIjoiMkhhbmRzaGFyaW5nSWRlbnRpdHlVc2VyIn0.OuaDWSBvQk4dWuBKZDdzGXMBthIQOGZihCbcr0_CBJI",
      "Content-Type": "application/json"
    });
    var itemModel = ItemModel.fromJson(jsonDecode(response.body));
    return itemModel.items;
  }
}
