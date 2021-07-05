class Post {
  Post({
    this.id,
    this.content,
    this.postTime,
    this.imageUrl,
    this.postByAccountId,
    this.postByAccountName,
    this.avatarUrl,
  });

  int id;
  String content;
  DateTime postTime;
  List<String> imageUrl;
  int postByAccountId;
  String postByAccountName;
  String avatarUrl;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        content: json["content"],
        postTime: DateTime.parse(json["postTime"]),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        postByAccountId: json["postByAccountId"],
        postByAccountName: json["postByAccountName"],
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "postTime": postTime.toIso8601String(),
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "postByAccountId": postByAccountId,
        "postByAccountName": postByAccountName,
        "avatarUrl": avatarUrl,
      };
}
