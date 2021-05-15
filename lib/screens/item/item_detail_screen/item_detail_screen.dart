import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item_detail_model/item_detail.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/images_view/images_view.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/register_form/register_form.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/user_info_card/user_info_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/services/api_services/receive_services/receive_services.dart';

class ItemDetailScreen extends StatefulWidget {
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  ItemDetail _itemDetail = ItemDetail();
  RequestStatus _requestStatus;
  bool _isLoading = true;
  bool _requested = false;
  bool _isCanceling = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ItemServices.getItemDetail(_itemDetail.id).then((value) {
        if (value != null) {
          setState(() {
            _itemDetail = value;
            if (_itemDetail.userRequestId != 0) {
              _requested = true;
            }
          });
          if (_itemDetail.userRequestId == 0) {
            setState(() {
              _requestStatus = RequestStatus.cancel;
              _isLoading = false;
            });
          } else
            ReceiveServices.getRequestDetail(_itemDetail.userRequestId)
                .then((value) {
              if (value != null) {
                setState(() {
                  _requestStatus = value.receiveStatus;
                });
              }
              setState(() {
                _isLoading = false;
              });
            });
        }
      });
    });
    super.initState();
  }

  void _onRegisterToReceive() {
    showDialog(
            context: context,
            builder: (context) {
              return RegisterForm();
            },
            routeSettings: RouteSettings(arguments: _itemDetail.id))
        .then((value) {
      setState(() {
        if (value != null) {
          _requested = value;
          if (_requested) {
            _requestStatus = RequestStatus.pending;
          }
        }
      });
    });
  }

  Future<void> _onCancelRegistration() async {
    setState(() {
      _isCanceling = true;
    });
    var result =
        await ReceiveServices.cancelRegistration(_itemDetail.userRequestId);
    if (result) {
      setState(() {
        _requested = false;
      });
    }
    setState(() {
      _isCanceling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_itemDetail.id == null) {
      _itemDetail.id = ModalRoute.of(context).settings.arguments;
      print(_itemDetail.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).detail,
          style: Theme.of(context).textTheme.headline2,
        ),
        actions: [
          Center(
            widthFactor: 1.4,
            child: Text(
              _requestStatus == null
                  ? ""
                  : _requestStatus == RequestStatus.cancel
                      ? S.of(context).unregistered
                      : _requestStatus == RequestStatus.pending
                          ? S.of(context).pending
                          : _requestStatus == RequestStatus.receiving
                              ? S.of(context).accepted
                              : S.of(context).success,
              style: TextStyle(
                  color: _requestStatus == RequestStatus.cancel
                      ? Theme.of(context).disabledColor
                      : _requestStatus == RequestStatus.pending
                          ? Theme.of(context).primaryColor
                          : Colors.green),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    UserInfoCard(_itemDetail.donateAccountName,
                        _itemDetail.receiveAddress, () {}),
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
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                          onPressed: _requested
                              ? _isCanceling
                                  ? null
                                  : _onCancelRegistration
                              : _onRegisterToReceive,
                          child: Text(_requested
                              ? S.of(context).cancelRegister
                              : S.of(context).registerToReceive)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
