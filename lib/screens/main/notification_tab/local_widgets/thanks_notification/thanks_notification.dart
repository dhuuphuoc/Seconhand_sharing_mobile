import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/message/user_message.dart';
import 'package:secondhand_sharing/models/notification/notification.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';

class ThanksNotification extends StatefulWidget {
  final UserNotification notification;

  ThanksNotification(this.notification);

  @override
  _ThanksNotificationState createState() => _ThanksNotificationState();
}

class _ThanksNotificationState extends State<ThanksNotification> {
  UserMessage _message;

  @override
  void initState() {
    _message = UserMessage.fromJson(jsonDecode(widget.notification.data));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var userInfo = await UserServices.getUserInfoById(_message.sendFromAccountId);
        Navigator.of(context).pushNamed("/chat", arguments: userInfo);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          minVerticalPadding: 10,
          leading: Avatar(_message.sendFromAccountAvatarUrl, 20),
          title: RichText(
            text: TextSpan(
                text: "${_message.sendFromAccountName}",
                style: Theme.of(context).textTheme.headline3,
                children: [
                  TextSpan(
                    text: " ${S.of(context).sentThanksToYou}",
                    style: DefaultTextStyle.of(context).style,
                  ),
                  TextSpan(
                    text: " ${_message.content}",
                    style: DefaultTextStyle.of(context).style,
                  ),
                ]),
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
