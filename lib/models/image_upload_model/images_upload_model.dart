import 'package:secondhand_sharing/models/image_upload_model/image_upload.dart';

class ImagesUploadModel {
  ImagesUploadModel({
    this.id,
    this.imageUploads,
  });

  int id;
  List<ImageUpload> imageUploads;

  factory ImagesUploadModel.fromJson(Map<String, dynamic> json) => ImagesUploadModel(
        id: json["id"],
        imageUploads: List<ImageUpload>.from(json["imageUploads"].map((x) => ImageUpload.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageUploads": List<dynamic>.from(imageUploads.map((x) => x.toJson())),
      };
}
