import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item_detail_model/item_detail.dart';
import 'package:secondhand_sharing/models/item_detail_model/item_status.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_requests_model.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/images_view/images_view.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/register_form/register_form.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/requests_expansion_panel/requests_expansion_panel.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/send_thanks_form/send_thanks_form.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/user_info_card/user_info_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/services/api_services/receive_services/receive_services.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/services/firebase_services/firebase_services.dart';
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
        if (_isOwn) {
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
        setState(() {
          _isLoading = false;
        });
      }
    });

    super.initState();
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
    var result = await ReceiveServices.cancelRegistration(_itemDetail.userRequestId);
    if (result) {
      setState(() {
        _itemDetail.userRequestId = 0;
        _requestStatus = null;
      });
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
              S.of(context).confirmationMessage,
            )).then((value) {
      if (value) {
        ItemServices.confirmSent(_itemDetail.id).then((value) {
          if (value) {
            Navigator.pop(context);
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
      FirebaseServices.watchingItemId = _itemDetail.id;
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
                      if (_isOwn)
                        SizedBox(
                          height: 15,
                        ),
                      if (_isOwn && _itemDetail.status != ItemStatus.success) RequestsExpansionPanel(),
                      if (_itemDetail.status != ItemStatus.success || !_isOwn)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          child: _isOwn
                              ? ElevatedButton(
                                  onPressed: context.watch<ReceiveRequestsModel>().acceptedRequest != null
                                      ? _confirmSent
                                      : null,
                                  child: Text(S.of(context).confirmSent))
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
