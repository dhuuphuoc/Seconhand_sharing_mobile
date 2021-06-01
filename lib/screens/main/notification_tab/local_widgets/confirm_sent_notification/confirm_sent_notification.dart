import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/notification_model/confirm_sent_model/confirm_sent_model.dart';
import 'package:secondhand_sharing/models/notification_model/notification.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';

class ConfirmSentNotification extends StatefulWidget {
  final UserNotification notification;

  ConfirmSentNotification(this.notification);

  @override
  _ConfirmSentNotificationState createState() => _ConfirmSentNotificationState();
}

class _ConfirmSentNotificationState extends State<ConfirmSentNotification> {
  ConfirmSentModel _confirmSentModel;

  void initState() {
    _confirmSentModel = ConfirmSentModel.fromJson(jsonDecode(widget.notification.data));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/item/detail", arguments: _confirmSentModel.itemId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          minVerticalPadding: 10,
          leading: CircleAvatar(
            radius: 20,
            child: Icon(Icons.app_registration),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _confirmSentModel.itemName,
                style: Theme.of(context).textTheme.headline3,
              ),
              RichText(
                  text:
                      TextSpan(text: S.of(context).confirmSentTo, style: DefaultTextStyle.of(context).style, children: [
                TextSpan(
                    text: _confirmSentModel.receiverId == AccessInfo().userInfo.id
                        ? " ${S.of(context).you}"
                        : " ${_confirmSentModel.receiverName}",
                    style: Theme.of(context).textTheme.headline3)
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
