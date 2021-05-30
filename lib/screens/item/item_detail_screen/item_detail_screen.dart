import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item_detail_model/item_detail.dart';
import 'package:secondhand_sharing/models/item_detail_model/item_status.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'package:secondhand_sharing/models/notification_model/cancel_request_model/cancel_request_model.dart';
import 'package:secondhand_sharing/models/notification_model/confirm_sent_model/confirm_sent_model.dart';
import 'package:secondhand_sharing/models/notification_model/request_status_model/request_status_model.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_requests_model.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';
import 'package:secondhand_sharing/screens/application/application.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/images_view/images_view.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/register_form/register_form.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/requests_expansion_panel/requests_expansion_panel.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/send_thanks_form/send_thanks_form.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/user_info_card/user_info_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/services/api_services/receive_services/receive_services.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/services/firebase_services/firebase_services.dart';
import 'package:secondhand_sharing/services/notification_services/notification_services.dart';
import 'package:secondhand_sharing/widgets/dialog/confirm_dialog/confirm_dialog.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';

class ItemDetailScreen extends StatefulWidget {
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  ItemDetail _itemDetail = ItemDetail();
  bool _isOwn = false;
  RequestStatus _requestStatus;
  ReceiveRequestsModel _receiveRequestsModel = ReceiveRequestsModel(requests: []);
  UserInfo _receivedUserInfo;
  StreamSubscription<RemoteMessage> _subscription;
  bool _isLoading = true;
  bool _isCanceling = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      ItemDetail itemDetail = await ItemServices.getItemDetail(_itemDetail.id);
      if (itemDetail != null) {
        setState(() {
          _isOwn = AccessInfo().userInfo.id == itemDetail.donateAccountId;
          _itemDetail = itemDetail;
        });
        if (_isOwn && _itemDetail.status != ItemStatus.success) {
          var requests = await ReceiveServices.getItemRequests(itemDetail.id);
          if (requests != null) {
            setState(() {
              _receiveRequestsModel.requests = requests;
              _receiveRequestsModel.acceptedRequest = _receiveRequestsModel.requests
                  .firstWhere((element) => element.requestStatus == RequestStatus.receiving, orElse: () {
                return null;
              });
            });
          }
        } else if (_itemDetail.userRequestId != 0) {
          var requestDetail = await ReceiveServices.getRequestDetail(_itemDetail.userRequestId);
          if (requestDetail != null) {
            setState(() {
              _requestStatus = requestDetail.receiveStatus;
            });
          }
        }
        if (_itemDetail.status == ItemStatus.success) {
          _receivedUserInfo = await ItemServices.getReceivedUserInfo(_itemDetail.id);
        }
        _subscription = FirebaseMessaging.onMessage.listen((message) {
          final scaffold = ScaffoldMessenger.of(context);
          if (_isOwn)
            switch (message.data["type"]) {
              case "2":
                ReceiveRequest receiveRequest = ReceiveRequest.fromJson(jsonDecode(message.data["message"]));
                if (receiveRequest.itemId != _itemDetail.id) return;
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).incomingReceiveRequestSnackBar(receiveRequest.receiverName)),
                  ),
                );
                receiveRequest.requestStatus = RequestStatus.pending;
                setState(() {
                  _receiveRequestsModel.requests.add(receiveRequest);
                });
                break;
              case "3":
                var data = CancelRequestModel.fromJson(jsonDecode(message.data["message"]));

                if (_itemDetail.id != data.itemId) return;
                int requestId = data.requestId;
                setState(() {
                  _receiveRequestsModel.requests.removeWhere((request) {
                    if (request.id == requestId) {
                      if (_receiveRequestsModel.acceptedRequest?.id == requestId) {
                        _receiveRequestsModel.acceptedRequest = null;
                      }
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).cancelReceiveRequestSnackBar(request.receiverName)),
                        ),
                      );
                      return true;
                    }
                    return false;
                  });
                });
                break;
            }
          else {
            switch (message.data["type"]) {
              case "4":
                var data = RequestStatusModel.fromJson(jsonDecode(message.data["message"]));
                if (_itemDetail.id != data.itemId) return;
                scaffold.showSnackBar(
                  SnackBar(
                    content: data.requestStatus == RequestStatus.receiving
                        ? Text(S.of(context).acceptedRequestNotification)
                        : Text(S.of(context).cancelAcceptRequestNotification),
                  ),
                );
                setState(() {
                  _requestStatus = data.requestStatus;
                });
                break;
              case "6":
                var data = ConfirmSentModel.fromJson(jsonDecode(message.data["message"]));
                showDialog(
                    context: context,
                    builder: (context) {
                      return NotifyDialog(
                          S.of(context).notification,
                          S.of(context).confirmSentNotification(
                              data.receiverId == AccessInfo().userInfo.id ? S.of(context).you : data.receiverName),
                          "Ok");
                    });
                setState(() {
                  _itemDetail.status = ItemStatus.success;
                  _receivedUserInfo = UserInfo(id: data.receiverId, fullName: data.receiverName);
                });
            }
          }
        });
        setState(() {
          _isLoading = false;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    Application().watchingItemId = null;
    super.dispose();
  }

  void _registerToReceive() {
    showDialog(
            context: context,
            builder: (context) {
              return RegisterForm();
            },
            routeSettings: RouteSettings(arguments: _itemDetail.id))
        .then((value) {
      setState(() {
        if (value != null) {
          _requestStatus = RequestStatus.pending;
          _itemDetail.userRequestId = value;
        }
      });
    });
  }

  Future<void> _cancelRegistration() async {
    setState(() {
      _isCanceling = true;
    });
    var confirm = await showDialog(
        context: context,
        builder: (context) => ConfirmDialog(S.of(context).cancelRegister, S.of(context).cancelRegistrationMessage));
    if (confirm) {
      var result = await ReceiveServices.cancelRegistration(_itemDetail.userRequestId);
      if (result) {
        setState(() {
          _itemDetail.userRequestId = 0;
          _requestStatus = null;
        });
      }
    }
    setState(() {
      _isCanceling = false;
    });
  }

  void _confirmSent() {
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              S.of(context).confirmSent,
              S.of(context).confirmationSentMessage,
            )).then((value) {
      if (value) {
        ItemServices.confirmSent(_itemDetail.id).then((value) {
          if (value) {
            setState(() {
              _itemDetail.status = ItemStatus.success;
              _receivedUserInfo = UserInfo(
                  id: _receiveRequestsModel.acceptedRequest.receiverId,
                  fullName: _receiveRequestsModel.acceptedRequest.receiverName);
            });
            showDialog(
                context: context,
                builder: (context) {
                  return NotifyDialog(S.of(context).notification,
                      S.of(context).confirmSentSuccess(_receiveRequestsModel.acceptedRequest.receiverName), "Ok");
                });
          }
        });
      }
    });
  }

  void sendThanks() {
    showDialog(
      context: context,
      builder: (context) {
        return SendThanksForm();
      },
      routeSettings: RouteSettings(arguments: _itemDetail.userRequestId),
    ).then((value) => {
          if (value != null)
            {
              if (value)
                {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return NotifyDialog(S.of(context).success, S.of(context).thanksSent, "Ok");
                      })
                }
            }
        });
  }

  void showUserProfile() {
    Navigator.pushNamed(context, '/profile', arguments: _itemDetail.donateAccountId);
  }

  @override
  Widget build(BuildContext context) {
    if (_itemDetail.id == null) {
      _itemDetail.id = ModalRoute.of(context).settings.arguments;
      Application().watchingItemId = _itemDetail.id;
      print(_itemDetail.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).detail,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
        actions: [
          if (!_isLoading)
            Center(
              child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: _itemDetail.status == ItemStatus.success
                      ? Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        )
                      : !_isOwn
                          ? _itemDetail.userRequestId == 0
                              ? Icon(
                                  Icons.app_registration,
                                  color: Colors.black54,
                                )
                              : _requestStatus == RequestStatus.pending
                                  ? Icon(
                                      Icons.app_registration,
                                    )
                                  : Icon(
                                      Icons.fact_check_outlined,
                                      color: Colors.green,
                                    )
                          : null),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SingleChildScrollView(
                child: ChangeNotifierProvider(
                  create: (context) => _receiveRequestsModel,
                  builder: (context, widget) => Column(
                    children: [
                      SizedBox(height: 10),
                      UserInfoCard(_itemDetail.donateAccountName, _itemDetail.receiveAddress, showUserProfile),
                      SizedBox(height: 10),
                      ImagesView(
                        images: _itemDetail.imageUrl,
                        itemName: _itemDetail.itemName,
                        description: _itemDetail.description,
                      ),
                      if (_isCanceling)
                        SizedBox(
                          height: 15,
                        ),
                      if (_isCanceling)
                        Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        ),
                      if (_isOwn && _itemDetail.status != ItemStatus.success)
                        SizedBox(
                          height: 10,
                        ),
                      if (_isOwn && _itemDetail.status != ItemStatus.success) RequestsExpansionPanel(),
                      if (_itemDetail.status == ItemStatus.success)
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/profile", arguments: _receivedUserInfo.id);
                          },
                          child: Container(
                            width: double.infinity,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  SizedBox(height: 10),
                                  Text(S.of(context).sentNotification(_receivedUserInfo.id == AccessInfo().userInfo.id
                                      ? S.of(context).you
                                      : _receivedUserInfo.fullName)),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: _itemDetail.status == ItemStatus.success ? 0 : 10),
                        width: double.infinity,
                        child: _isOwn
                            ? _itemDetail.status != ItemStatus.success
                                ? ElevatedButton(
                                    onPressed: context.watch<ReceiveRequestsModel>().acceptedRequest != null
                                        ? _confirmSent
                                        : null,
                                    child: Text(S.of(context).confirmSent))
                                : null
                            : _itemDetail.status == ItemStatus.success
                                ? ElevatedButton(
                                    onPressed: _itemDetail.userRequestId != 0 ? sendThanks : null,
                                    child: Text(S.of(context).sendThanks))
                                : ElevatedButton(
                                    onPressed: _itemDetail.userRequestId != 0
                                        ? _isCanceling
                                            ? null
                                            : _cancelRegistration
                                        : _registerToReceive,
                                    child: Text(_itemDetail.userRequestId != 0
                                        ? S.of(context).cancelRegister
                                        : S.of(context).registerToReceive)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
