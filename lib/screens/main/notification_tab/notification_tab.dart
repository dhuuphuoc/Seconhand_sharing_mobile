import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/notification_model/cancel_request_model/cancel_request_model.dart';
import 'package:secondhand_sharing/models/notification_model/notification.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
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
  int _pageNumber = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    UserNotificationServices.getNotifications(_pageNumber).then((value) {
      setState(() {
        _notifications.addAll(value);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
    if (_isLoading) {
      listViewWidgets.add(Container(
        height: screenSize.height * 0.7,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else if (_notifications.isEmpty) {
      listViewWidgets.add(Container(
        height: screenSize.height * 0.2,
        child: Center(
          child: Text(
            S.of(context).emptyNotification,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ));
    } else {
      for (var notification in _notifications) {
        if (notification.type == 2) {
          // print(notification.data);
          ReceiveRequest receiveRequest = ReceiveRequest.fromJson(jsonDecode(notification.data));
          listViewWidgets.add(Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              minVerticalPadding: 10,
              leading: CircleAvatar(
                radius: 20,
                foregroundImage: AssetImage(
                  "assets/images/person.png",
                ),
              ),
              title: Text(
                  "${S.current.incomingReceiveRequest(receiveRequest.receiverName, receiveRequest.itemName, receiveRequest.receiveReason)}"),
              subtitle:
                  Text(TimeAgo.parse(receiveRequest.createDate, locale: Localizations.localeOf(context).languageCode)),
            ),
          ));
        }
      }
    }

    return CustomScrollView(
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
    );
  }
}
