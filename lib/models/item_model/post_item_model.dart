class PostItemModel {
  PostItemModel({
    this.succeeded,
    this.message,
    this.data,
  });

  bool succeeded;
  dynamic message;
  ImageUploadModel data;

  factory PostItemModel.fromJson(Map<String, dynamic> json) => PostItemModel(
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

class ImageUploadModel {
  ImageUploadModel({
    this.id,
    this.imageUploads,
  });

  int id;
  List<ImageUpload> imageUploads;

  factory ImageUploadModel.fromJson(Map<String, dynamic> json) =>
      ImageUploadModel(
        id: json["id"],
        imageUploads: List<ImageUpload>.from(
            json["imageUploads"].map((x) => ImageUpload.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageUploads": List<dynamic>.from(imageUploads.map((x) => x.toJson())),
      };
}

class ImageUpload {
  ImageUpload({
    this.imageName,
    this.presignUrl,
  });

  String imageName;
  String presignUrl;

  factory ImageUpload.fromJson(Map<String, dynamic> json) => ImageUpload(
        imageName: json["imageName"],
        presignUrl: json["presignUrl"],
      );

  Map<String, dynamic> toJson() => {
        "imageName": imageName,
        "presignUrl": presignUrl,
      };
}
