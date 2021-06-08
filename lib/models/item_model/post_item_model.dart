import 'package:secondhand_sharing/models/image_upload_model/image_upload.dart';
import 'package:secondhand_sharing/models/image_upload_model/images_upload_model.dart';

class PostItemModel {
  PostItemModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  ImagesUploadModel data;

  factory PostItemModel.fromJson(Map<String, dynamic> json) => PostItemModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: ImagesUploadModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data.toJson(),
      };
}
