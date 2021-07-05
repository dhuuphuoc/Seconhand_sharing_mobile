import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/image_upload_model/images_upload_model.dart';
import 'package:secondhand_sharing/models/post/post.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

class PostForm {
  PostForm({
    this.content,
    this.visibility,
    this.imageNumber,
    this.groupId,
  });

  String content;
  int visibility;
  int imageNumber;
  int groupId;

  factory PostForm.fromJson(Map<String, dynamic> json) => PostForm(
        content: json["content"],
        visibility: json["visibility"],
        imageNumber: json["imageNumber"],
        groupId: json["groupId"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "visibility": visibility,
        "imageNumber": imageNumber,
        "groupId": groupId,
      };
}

class PostServices {
  static Future<List<Post>> getPosts(int groupId, int pageNumber, int pageSize) async {
    Uri url = Uri.https(APIService.apiUrl, "/GroupPost", {
      "PageNumber": pageNumber.toString(),
      "PageSize": pageSize.toString(),
      "GroupId": groupId.toString(),
    });
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
    });
    print(response.body);
    return List<Post>.from(ResponseDeserializer.deserializeResponseToList(response).map((x) => Post.fromJson(x)));
  }

  static Future<ImagesUploadModel> post(PostForm postForm) async {
    Uri postItemsUrl = Uri.https(APIService.apiUrl, "/GroupPost");
    var response = await http.post(postItemsUrl,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${AccessInfo().token}",
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        },
        body: jsonEncode(postForm.toJson()));
    print(response.body);
    if (response.statusCode == 200)
      return ImagesUploadModel.fromJson(jsonDecode(response.body)["data"]);
    else
      return null;
  }
}
