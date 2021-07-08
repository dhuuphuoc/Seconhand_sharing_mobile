import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/invitation/invitation.dart';
import 'package:secondhand_sharing/models/notification/notification.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';

class InvitationNotification extends StatefulWidget {
  final UserNotification notification;

  InvitationNotification(this.notification);

  @override
  _ConfirmSentNotificationState createState() => _ConfirmSentNotificationState();
}

class _ConfirmSentNotificationState extends State<InvitationNotification> {
  Invitation _invitation;

  void initState() {
    _invitation = Invitation.fromJson(jsonDecode(widget.notification.data));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/group/detail", arguments: _invitation.groupId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          minVerticalPadding: 10,
          leading: Avatar(_invitation.avatarUrl, 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _invitation.groupName,
                style: Theme.of(context).textTheme.headline3,
              ),
              RichText(
                  text: TextSpan(
                text: S.of(context).receivedInvitationNotification,
                style: DefaultTextStyle.of(context).style,
              ))
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
