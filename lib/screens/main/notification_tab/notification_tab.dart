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

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key key}) : super(key: key);

  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  List<UserNotification> _notifications = [];
  ScrollController _primaryScrollController;
  int _pageNumber = 1;
  int _pageSize = 10;
  bool _isLoading = true;
  bool _isEnd = false;
  bool _isPresent = true;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    fetchNotification();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _primaryScrollController.addListener(() {
        TabBar tabBar = Keys.tabBarKey.currentWidget;
        if (tabBar.controller.index == 4) {
          if (_primaryScrollController.offset == _primaryScrollController.position.maxScrollExtent) {
            if (!_isEnd) {
              _pageNumber++;
              fetchNotification();
            }
          }
        }
      });
      TabBar tabBar = Keys.tabBarKey.currentWidget;
      tabBar.controller.addListener(() {
        TabController tabController = tabBar.controller;
        if (tabController.indexIsChanging) {
          if (tabController.index != 4) {
            _scrollOffset = _primaryScrollController.offset;
            setState(() {
              _isPresent = false;
            });
          } else {
            setState(() {
              _isPresent = true;
            });
          }
        }
      });
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
    while (_notifications.length < _pageSize) {
      var notifications = await UserNotificationServices.getNotifications(_pageNumber, _pageSize);
      if (notifications.isEmpty) {
        setState(() {
          _isEnd = true;
        });
        break;
      }
      setState(() {
        group(notifications);
        _notifications.addAll(notifications);
        _isLoading = false;
      });
      _pageNumber++;
    }
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
    if (_isPresent) {
      _primaryScrollController = PrimaryScrollController.of(context);
      if (_scrollOffset != 0) {
        print(_scrollOffset);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _primaryScrollController.jumpTo(_scrollOffset);
        });
      }
    }
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> listViewWidgets = [];
    listViewWidgets.add(Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: screenSize.height * 0.07,
      color: Theme.of(context).backgroundColor,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).notification,
            style: Theme.of(context).textTheme.headline2,
          )),
    ));
    listViewWidgets.add(SizedBox(
      height: 8,
    ));
    if (_isLoading) {
      listViewWidgets.add(Container(
        height: screenSize.height * 0.7,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else {
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
    return _isPresent
        ? RefreshIndicator(
            edgeOffset: screenSize.height * 0.2,
            onRefresh: () async {
              _notifications = [];
              _pageNumber = 1;
              await fetchNotification();
            },
            child: CustomScrollView(
              controller: _primaryScrollController,
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
          )
        : Container();
  }
}
