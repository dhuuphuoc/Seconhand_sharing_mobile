class Glory {
  Glory({
    this.accountId,
    this.donateAccountName,
    this.avatarUrl,
  });

  int accountId;
  String donateAccountName;
  String avatarUrl;

  factory Glory.fromJson(Map<String, dynamic> json) => Glory(
        accountId: json["accountId"],
        donateAccountName: json["donateAccountName"],
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "accountId": accountId,
        "donateAccountName": donateAccountName,
        "avatarUrl": avatarUrl,
      };
}
