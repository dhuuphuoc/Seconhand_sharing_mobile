class Comment {
  Comment({
    this.avatarUrl,
    this.id,
    this.postId,
    this.content,
    this.postByAccountId,
    this.postByAccountName,
    this.postTime,
  });

  dynamic avatarUrl;
  int id;
  int postId;
  String content;
  int postByAccountId;
  String postByAccountName;
  DateTime postTime;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        avatarUrl: json["avatarUrl"],
        id: json["id"],
        postId: json["postId"],
        content: json["content"],
        postByAccountId: json["postByAccontId"],
        postByAccountName: json["postByAccountName"],
        postTime: DateTime.parse(json["postTime"]),
      );

  Map<String, dynamic> toJson() => {
        "avatarUrl": avatarUrl,
        "id": id,
        "postId": postId,
        "content": content,
        "postByAccountId": postByAccountId,
        "postTime": postTime.toIso8601String(),
      };
}
