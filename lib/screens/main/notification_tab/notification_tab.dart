import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/notification/cancel_request_model/cancel_request_model.dart';
import 'package:secondhand_sharing/models/notification/notification.dart';
import 'package:secondhand_sharing/models/enums/notification_type/notification_type.dart';
import 'package:secondhand_sharing/models/receive_request/receive_request.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/Join_request_notification/join_request_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/accept_invitation_notification/accept_invitation_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/confirm_sent_notification/confirm_sent_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/incoming_request_notification/incoming_request_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/invitation_notification/invitation_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/request_status_notification/request_status_notification.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/local_widgets/thanks_notification/thanks_notification.dart';
import 'package:secondhand_sharing/services/api_services/user_notification_services/user_notification_services.dart';
import 'package:secondhand_sharing/utils/scroll_absorber/scroll_absorber.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key key}) : super(key: key);

  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> with AutomaticKeepAliveClientMixin<NotificationTab> {
  List<UserNotification> _notifications = [];
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  int _pageSize = 10;
  bool _isLoading = true;
  bool _isEnd = false;
  StreamSubscription<RemoteMessage> _subscription;
  @override
  void initState() {
    super.initState();
    _subscription = FirebaseMessaging.onMessage.listen((message) {
      if (message.data["type"] == "3") {
        CancelRequestModel cancelRequest = CancelRequestModel.fromJson(jsonDecode(message.data["message"]));
        var requestNotifications = _notifications.where((element) => element.type == NotificationType.receiveRequest);
        var result = requestNotifications.firstWhere((element) {
          ReceiveRequest receiveRequest = ReceiveRequest.fromJson(jsonDecode(element.data));
          return receiveRequest.id == cancelRequest.requestId;
        });

        setState(() {
          _notifications.remove(result);
        });
        return;
      }
      UserNotification userNotification = UserNotification(
          type: NotificationType.values[int.tryParse(message.data["type"])],
          data: message.data["message"],
          userId: AccessInfo().userInfo.id,
          createTime: message.sentTime);
      setState(() {
        _notifications.insert(0, userNotification);
      });
    });
    fetchNotification();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        if (!_isEnd && !_isLoading) {
          _pageNumber++;
          fetchNotification();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
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
    setState(() {
      if (notifications.length < _pageSize) {
        _isEnd = true;
      }
      _notifications.addAll(notifications);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> listViewWidgets = [];
    listViewWidgets.add(Container(
      padding: EdgeInsets.only(left: 12, right: 5),
      height: screenSize.height * 0.07,
      color: Theme.of(context).backgroundColor,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          S.of(context).notification,
          style: Theme.of(context).textTheme.headline2,
        ),
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
        case NotificationType.inviteMember:
          listViewWidgets.add(InvitationNotification(notification));
          break;
        case NotificationType.acceptInvitation:
          listViewWidgets.add(AcceptInvitationNotification(notification));
          break;
        case NotificationType.joinRequest:
          listViewWidgets.add(JoinRequestNotification(notification));
          break;
        default:
          break;
      }
    }
    listViewWidgets.add(Container(
      height: _isEnd ? 0 : screenSize.height * 0.2,
      child: Center(
        child: _isLoading ? MiniIndicator() : Container(),
      ),
    ));
    if (_isEnd) {
      listViewWidgets.add(Container(
        height: screenSize.height * 0.2,
        child: Center(
          child: Text(
            S.of(context).notificationEnded,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ));
    }
    return NotificationListener(
      onNotification: (notification) {
        ScrollAbsorber.absorbScrollNotification(notification, ScreenType.main);
        if (notification is OverscrollNotification) {
          if (notification.overscroll > 0) {
            if (!_isEnd && !_isLoading) {
              _pageNumber++;
              fetchNotification();
            }
          }
        }

        return true;
      },
      child: RefreshIndicator(
        edgeOffset: screenSize.height * 0.02,
        onRefresh: () async {
          _notifications = [];
          _isEnd = false;
          _pageNumber = 1;

          await fetchNotification();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          cacheExtent: double.infinity,
          slivers: [
            SliverOverlapInjector(
              // This is the flip side of the SliverOverlapAbsorber
              // above.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0),
              sliver: SliverList(delegate: SliverChildListDelegate(listViewWidgets)),
            )
          ],
          // ListView(
          //   padding: EdgeInsets.only(bottom: 10),
          //   controller: _scrollController,
          //   children: listViewWidgets,
          //   // ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
