import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:http/http.dart' as http;

class APIService {
  // static String apiUrl = "10.0.2.2:5001";
  static String apiUrl = "secondhandsharing-316714.as.r.appspot.com";
  static String cloudUrl = "https://storage.googleapis.com/secondhandsharing.appspot.com/";

  static Future<void> handle401StatusCode() async {
    await Keys.navigatorKey.currentState.pushNamed("/login");
  }

  static Future<bool> uploadImage(ImageData image, String url) async {
    Uri uploadUrl = Uri.parse(url);
    print(uploadUrl.toString());
    var response = await http.put(uploadUrl, body: image.data, headers: {HttpHeaders.contentTypeHeader: "image/png"});
    print(response.body);
    if (response.statusCode == 200) return true;
    return false;
  }

  static Future<String> downloadAndSaveFile(String url, String fileName) async {
    if (url == null) return null;
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    print(filePath);
    final response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
