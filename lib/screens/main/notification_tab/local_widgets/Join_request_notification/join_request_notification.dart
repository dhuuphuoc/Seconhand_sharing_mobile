import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/notification/join_request_model/join_request_model.dart';
import 'package:secondhand_sharing/models/notification/notification.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';

class JoinRequestNotification extends StatefulWidget {
  final UserNotification notification;

  JoinRequestNotification(this.notification);

  @override
  _IncomingRequestNotificationState createState() => _IncomingRequestNotificationState();
}

class _IncomingRequestNotificationState extends State<JoinRequestNotification> {
  JoinRequestModel _joinRequestModel;

  @override
  void initState() {
    super.initState();
    _joinRequestModel = JoinRequestModel.fromJson(jsonDecode(widget.notification.data));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/group/detail", arguments: _joinRequestModel.groupId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          minVerticalPadding: 10,
          leading: Avatar(_joinRequestModel.avatarUrl, 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _joinRequestModel.groupName,
                style: Theme.of(context).textTheme.headline3,
              ),
              RichText(
                  text: TextSpan(text: "${_joinRequestModel.fullName} ", style: Theme.of(context).textTheme.headline3, children: [
                TextSpan(
                  text: S.of(context).joinRequestNotification,
                  style: DefaultTextStyle.of(context).style,
                )
              ]))
            ],
          ),
          subtitle: Text(
            TimeAgo.parse(widget.notification.createTime, locale: Localizations.localeOf(context).languageCode),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
    );
  }
}
