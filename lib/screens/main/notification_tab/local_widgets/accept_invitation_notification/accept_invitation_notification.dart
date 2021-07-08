import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/notification/accep_invitation_model/accept_invitation_model.dart';
import 'package:secondhand_sharing/models/notification/notification.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';

class AcceptInvitationNotification extends StatefulWidget {
  final UserNotification notification;

  AcceptInvitationNotification(this.notification);

  @override
  _ConfirmSentNotificationState createState() => _ConfirmSentNotificationState();
}

class _ConfirmSentNotificationState extends State<AcceptInvitationNotification> {
  AcceptInvitationModel _acceptInvitationModel;

  void initState() {
    _acceptInvitationModel = AcceptInvitationModel.fromJson(jsonDecode(widget.notification.data));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/group/detail", arguments: _acceptInvitationModel.groupId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          minVerticalPadding: 10,
          leading: Avatar(_acceptInvitationModel.avatarUrl, 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _acceptInvitationModel.groupName,
                style: Theme.of(context).textTheme.headline3,
              ),
              RichText(
                  text: TextSpan(
                      text: _acceptInvitationModel.fullName + " ",
                      style: Theme.of(context).textTheme.headline3,
                      children: [TextSpan(text: S.of(context).newMemberNotification, style: DefaultTextStyle.of(context).style)]))
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
