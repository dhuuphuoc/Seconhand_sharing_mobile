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
