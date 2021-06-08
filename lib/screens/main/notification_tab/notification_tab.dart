import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/notification_model/cancel_request_model/cancel_request_model.dart';
import 'package:secondhand_sharing/models/notification_model/notification.dart';
import 'package:secondhand_sharing/models/notification_model/notification_type.dart';
import 'package:secondhand_sharing/models/notification_model/request_status_model/request_status_model.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/confirm_sent_notification/confirm_sent_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/incoming_request_notification/incoming_request_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/request_status_notification/request_status_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/thanks_notification/thanks_notification.dart';
import 'package:secondhand_sharing/services/api_services/user_notification_services/user_notification_services.dart';
import 'package:secondhand_sharing/services/notification_services/notification_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key key}) : super(key: key);

  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  List<UserNotification> _notifications = [];
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  int _pageSize = 10;
  bool _isLoading = true;
  bool _isEnd = false;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    fetchNotification();
    NestedScrollView nestedScrollView = Keys.nestedScrollViewKey.currentWidget;
    ScrollController primaryScrollController = nestedScrollView.controller;
    _scrollController.addListener(() {
      double scrolled = _scrollController.offset - _lastOffset;
      _lastOffset = _scrollController.offset;
      primaryScrollController.jumpTo(primaryScrollController.offset + scrolled);
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        if (!_isEnd && !_isLoading) {
          _pageNumber++;
          fetchNotification();
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  Future<void> fetchNotification() async {
    setState(() {
      _isLoading = true;
    });
    var notifications = await UserNotificationServices.getNotifications(_pageNumber, _pageSize);
    if (notifications.isEmpty) {
      setState(() {
        _isEnd = true;
      });
    }
    setState(() {
      group(notifications);
      _notifications.addAll(notifications);
      _isLoading = false;
    });
  }

  void group(List<UserNotification> notifications) {
    for (int i = 0; i < notifications.length; i++) {
      if (notifications[i].type == NotificationType.receiveRequest) {
        ReceiveRequest receiveRequest = ReceiveRequest.fromJson(jsonDecode(notifications[i].data));
        for (int j = 0; j < i; j++) {
          if (notifications[j].type == NotificationType.cancelReceiveRequest) {
            CancelRequestModel cancelRequestModel = CancelRequestModel.fromJson(jsonDecode(notifications[j].data));
            if (cancelRequestModel.requestId == receiveRequest.id) {
              notifications.remove(notifications[i]);
              notifications.remove(notifications[j]);
              break;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> listViewWidgets = [];
    listViewWidgets.add(Container(
      padding: EdgeInsets.only(left: 12, right: 5),
      height: screenSize.height * 0.07,
      color: Theme.of(context).backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).notification,
            style: Theme.of(context).textTheme.headline2,
          ),
          Container(
            height: 50,
            width: 50,
            child: Card(
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(90),
                onTap: () {
                  Navigator.pushNamed(context, "/message-box");
                },
                child: Icon(
                  AppIcons.facebook_messenger,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
    listViewWidgets.add(SizedBox(
      height: 8,
    ));

    for (var notification in _notifications) {
      switch (notification.type) {
        case NotificationType.receiveRequest:
          ReceiveRequest receiveRequest = ReceiveRequest.fromJson(jsonDecode(notification.data));
          listViewWidgets.add(IncomingRequestNotification(receiveRequest));
          break;
        case NotificationType.requestStatus:
          listViewWidgets.add(RequestStatusNotification(notification));
          break;
        case NotificationType.confirmSent:
          listViewWidgets.add(ConfirmSentNotification(notification));
          break;
        case NotificationType.sendThanks:
          listViewWidgets.add(ThanksNotification(notification));
          break;
        default:
          break;
      }
    }
    if (_isLoading) {
      listViewWidgets.add(Container(
        height: screenSize.height * 0.3,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    }
    if (_isEnd) {
      listViewWidgets.add(Container(
        height: screenSize.height * 0.2,
        child: Center(
          child: Text(
            S.of(context).emptyNotification,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ));
    }
    return RefreshIndicator(
      edgeOffset: screenSize.height * 0.2,
      onRefresh: () async {
        _notifications = [];
        _pageNumber = 1;
        await fetchNotification();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 10),
            sliver: SliverList(delegate: SliverChildListDelegate(listViewWidgets)),
          )
        ],
        // ListView(
        //   controller: _postsScrollController,
        //   children: listViewWidgets,
        // ),
      ),
    );
  }
}
