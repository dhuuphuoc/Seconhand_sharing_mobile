import 'dart:convert';

import 'package:http/http.dart';

class ResponseDeserializer {
  static Map<String, dynamic> deserializeResponse(Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    } else {
      return null;
    }
  }

  static int deserializeResponseToInt(Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    } else {
      return null;
    }
  }

  static List<dynamic> deserializeResponseToList(Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    } else {
      return [];
    }
  }
}
