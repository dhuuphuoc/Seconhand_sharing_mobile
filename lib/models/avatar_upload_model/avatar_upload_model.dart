import 'package:secondhand_sharing/models/image_upload_model/image_upload_model.dart';

class AvatarUploadModel {
  AvatarUploadModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  ImageUploadModel data;

  factory AvatarUploadModel.fromJson(Map<String, dynamic> json) => AvatarUploadModel(
        succeeded: json["succeeded"],
        message: json["message"],
        data: ImageUploadModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": data.toJson(),
      };
}
