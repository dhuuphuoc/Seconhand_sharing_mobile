class JoinRequest {
  JoinRequest({
    this.requesterId,
    this.requesterName,
    this.joinStatus,
    this.createDate,
    this.avatarUrl,
  });

  int requesterId;
  String requesterName;
  int joinStatus;
  DateTime createDate;
  String avatarUrl;

  factory JoinRequest.fromJson(Map<String, dynamic> json) => JoinRequest(
        requesterId: json["requesterId"],
        requesterName: json["requesterName"],
        joinStatus: json["joinStatus"],
        createDate: DateTime.parse(json["createDate"]),
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "requesterId": requesterId,
        "requesterName": requesterName,
        "joinStatus": joinStatus,
        "createDate": createDate.toIso8601String(),
        "avatarUrl": avatarUrl,
      };
}
