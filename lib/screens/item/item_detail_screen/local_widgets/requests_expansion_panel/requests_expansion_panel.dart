import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_requests_model.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';
import 'package:secondhand_sharing/services/api_services/receive_services/receive_services.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/widgets/dialog/confirm_dialog/confirm_dialog.dart';

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
    bool result = await showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              S.of(context).cancelAccept,
              S.of(context).cancelAlert(receiveRequest.receiverName),
            ));
    if (result) {
      _receiveRequestsModel.cancelAcceptRequest();
      var success = await ReceiveServices.cancelReceiver(receiveRequest.id);
      if (success) {
        setState(() {
          receiveRequest.requestStatus = RequestStatus.pending;
        });
      }
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
                    .map((request) => InkWell(
                          onTap: () {
                            print(request.id);
                            Navigator.pushNamed(context, "/profile", arguments: request.receiverId);
                          },
                          child: Container(
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54))),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  foregroundImage: AssetImage(
                                    "assets/images/person.png",
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            request.receiverName,
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          if (request.requestStatus == RequestStatus.receiving)
                                            Text(
                                              S.of(context).accepted,
                                              style: TextStyle(color: Colors.green),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        "2 Phút trước",
                                        style: Theme.of(context).textTheme.subtitle2,
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(request.receiveReason == null ? "No reason" : request.receiveReason),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: _inProcessRequest != null
                                              ? null
                                              : () async {
                                                  if (request.requestStatus == RequestStatus.pending) {
                                                    if (_receiveRequestsModel.acceptedRequest != null) {
                                                      await cancelRequest(_receiveRequestsModel.acceptedRequest);
                                                    }
                                                    await acceptRequest(request);
                                                  } else {
                                                    if (request.requestStatus == RequestStatus.receiving) {
                                                      await cancelRequest(request);
                                                    }
                                                  }
                                                },
                                          style: ButtonStyle(
                                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
                                          child: _inProcessRequest == request
                                              ? Container(
                                                  height: 15,
                                                  width: 15,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : Text(request.requestStatus == RequestStatus.pending
                                                  ? S.of(context).accept
                                                  : S.of(context).cancelAccept),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
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
