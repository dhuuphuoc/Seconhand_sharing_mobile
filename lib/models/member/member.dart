class Member {
  Member({
    this.id,
    this.fullName,
    this.joinDate,
    this.avatarUrl,
  });

  int id;
  String fullName;
  DateTime joinDate;
  String avatarUrl;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["userId"],
        fullName: json["fullName"],
        joinDate: json["joinDate"] == null ? null : DateTime.parse(json["joinDate"]),
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "joinDate": joinDate.toIso8601String(),
        "avatarUrl": avatarUrl,
      };
}
