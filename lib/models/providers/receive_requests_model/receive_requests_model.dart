import 'package:flutter/foundation.dart';
import 'package:secondhand_sharing/models/receive_request/receive_request.dart';

class ReceiveRequestsModel extends ChangeNotifier {
  ReceiveRequestsModel({
    this.succeeded,
    this.message,
    this.requests,
  });

  bool succeeded;
  String message;
  List<ReceiveRequest> requests;
  ReceiveRequest acceptedRequest;

  void acceptRequest(ReceiveRequest receiveRequest) {
    this.acceptedRequest = receiveRequest;
    notifyListeners();
  }

  void cancelAcceptRequest() {
    this.acceptedRequest = null;
    notifyListeners();
  }

  factory ReceiveRequestsModel.fromJson(Map<String, dynamic> json) => ReceiveRequestsModel(
        succeeded: json["succeeded"],
        message: json["message"],
        requests: List<ReceiveRequest>.from(json["data"].map((x) => ReceiveRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "data": List<dynamic>.from(requests.map((x) => x.toJson())),
      };
}
