import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/notification_model/notification.dart';
import 'package:secondhand_sharing/models/notification_model/request_status_model/request_status_model.dart';
import 'package:secondhand_sharing/models/request_detail_model/request_status.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';

class RequestStatusNotification extends StatefulWidget {
  final UserNotification notification;

  RequestStatusNotification(this.notification);

  @override
  _RequestStatusNotificationState createState() => _RequestStatusNotificationState();
}

class _RequestStatusNotificationState extends State<RequestStatusNotification> {
  RequestStatusModel _requestStatusModel;
  @override
  void initState() {
    _requestStatusModel = RequestStatusModel.fromJson(jsonDecode(widget.notification.data));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/item/detail", arguments: _requestStatusModel.itemId);
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
                _requestStatusModel.itemName,
                style: Theme.of(context).textTheme.headline3,
              ),
              RichText(
                  text: TextSpan(
                      text: _requestStatusModel.requestStatus == RequestStatus.receiving
                          ? S.of(context).yourRegistrationWas
                          : S.of(context).yourAcceptedRegistrationWas,
                      style: DefaultTextStyle.of(context).style,
                      children: [
                    TextSpan(
                        text: _requestStatusModel.requestStatus == RequestStatus.receiving
                            ? " ${S.of(context).acceptedLowerCase}"
                            : " ${S.of(context).canceledLowerCase}",
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
