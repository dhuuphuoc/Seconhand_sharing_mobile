import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_requests_model.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';
import 'package:secondhand_sharing/services/api_services/receive_services/receive_services.dart';
import 'package:provider/provider.dart';

class RequestsExpansionPanel extends StatefulWidget {
  @override
  _RequestsExpansionPanelState createState() => _RequestsExpansionPanelState();
}

class _RequestsExpansionPanelState extends State<RequestsExpansionPanel> {
  bool _isRequestsExpanded = false;
  ReceiveRequestsModel _receiveRequestsModel;
  ReceiveRequest _inProcessRequest;

  Future<void> acceptRequest(ReceiveRequest receiveRequest) async {
    setState(() {
      _inProcessRequest = receiveRequest;
    });

    var success = await ReceiveServices.acceptRequest(receiveRequest.id);
    if (success) {
      setState(() {
        receiveRequest.requestStatus = RequestStatus.receiving;
      });
      _receiveRequestsModel.acceptRequest(receiveRequest);
    }
    setState(() {
      _inProcessRequest = null;
    });
  }

  Future<void> cancelRequest(ReceiveRequest receiveRequest) async {
    setState(() {
      _inProcessRequest = receiveRequest;
    });
    _receiveRequestsModel.cancelAcceptRequest();
    var success = await ReceiveServices.cancelReceiver(receiveRequest.id);
    if (success) {
      setState(() {
        receiveRequest.requestStatus = RequestStatus.pending;
      });
    }
    setState(() {
      _inProcessRequest = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _receiveRequestsModel = context.watch();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isRequestsExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  leading: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(S.of(context).registrations),
                );
              },
              canTapOnHeader: true,
              body: Column(
                children: _receiveRequestsModel.requests
                    .map((request) => ListTile(
                          onTap: () {
                            print(request.id);
                            ReceiveServices.getReceiverInfo(request.id)
                                .then((value) {
                              Navigator.pushNamed(context, "/profile",
                                  arguments: value);
                            });
                          },
                          leading: CircleAvatar(
                              maxRadius: 25,
                              child: Image.asset(
                                "assets/images/person.png",
                                height: 50,
                                fit: BoxFit.fill,
                              ),
                              backgroundColor: Colors.transparent),
                          title: Text(request.receiverName),
                          subtitle: Text(request.receiveReason == null
                              ? "No reason"
                              : request.receiveReason),
                          trailing: ElevatedButton(
                            onPressed: _inProcessRequest != null
                                ? null
                                : () async {
                                    if (request.requestStatus ==
                                        RequestStatus.pending) {
                                      if (_receiveRequestsModel
                                              .acceptedRequest !=
                                          null) {
                                        await cancelRequest(
                                            _receiveRequestsModel
                                                .acceptedRequest);
                                      }
                                      await acceptRequest(request);
                                    } else {
                                      if (request.requestStatus ==
                                          RequestStatus.receiving) {
                                        await cancelRequest(request);
                                      }
                                    }
                                  },
                            child: _inProcessRequest == request
                                ? Container(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(request.requestStatus ==
                                        RequestStatus.pending
                                    ? S.of(context).accept
                                    : S.of(context).cancel),
                          ),
                        ))
                    .toList(),
              ),
              isExpanded: _isRequestsExpanded),
        ],
      ),
    );
  }
}
