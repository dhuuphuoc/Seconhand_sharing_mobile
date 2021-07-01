import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/enums/request_status/request_status.dart';
import 'package:secondhand_sharing/models/providers/receive_requests_model/receive_requests_model.dart';
import 'package:secondhand_sharing/models/receive_request/receive_request.dart';
import 'package:secondhand_sharing/services/api_services/receive_services/receive_services.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
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
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ExpansionTile(
          leading: Icon(
            Icons.app_registration,
            // color: Theme.of(context).primaryColor,
          ),
          title: Text(S.of(context).registrations),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Text(
              _receiveRequestsModel.requests.length.toString(),
              style: TextStyle(color: _receiveRequestsModel.requests.isNotEmpty ? Colors.white : Colors.black54),
            ),
            decoration: BoxDecoration(
              color: _receiveRequestsModel.requests.isNotEmpty
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          children: _receiveRequestsModel.requests
              .map((request) => InkWell(
                    onTap: () {
                      print(request.id);
                      Navigator.pushNamed(context, "/profile", arguments: request.receiverId);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(request.receiverAvatarUrl, 20),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  TimeAgo.parse(request.createDate, locale: Localizations.localeOf(context).languageCode),
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
                                    style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
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
                                Divider(
                                  height: 5,
                                  thickness: 2,
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
      ),
    );
  }
}
