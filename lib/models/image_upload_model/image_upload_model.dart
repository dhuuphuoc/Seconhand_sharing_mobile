import 'package:secondhand_sharing/models/image_upload_model/image_upload.dart';

class ImageUploadModel {
  ImageUploadModel({
    this.id,
    this.imageUpload,
  });

  int id;
  ImageUpload imageUpload;

  factory ImageUploadModel.fromJson(Map<String, dynamic> json) => ImageUploadModel(
        id: json["id"],
        imageUpload: ImageUpload.fromJson(json["imageUploads"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageUploads": imageUpload.toJson(),
      };
}
