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
        id: json["id"],
        fullName: json["fullName"],
        joinDate: DateTime.parse(json["joinDate"]),
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "joinDate": joinDate.toIso8601String(),
        "avatarUrl": avatarUrl,
      };
}
