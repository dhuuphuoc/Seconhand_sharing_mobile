import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/receive_requests_model/receive_request.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';

class IncomingRequestNotification extends StatefulWidget {
  final ReceiveRequest receiveRequest;

  IncomingRequestNotification(this.receiveRequest);

  @override
  _IncomingRequestNotificationState createState() => _IncomingRequestNotificationState();
}

class _IncomingRequestNotificationState extends State<IncomingRequestNotification> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/item/detail", arguments: widget.receiveRequest.itemId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          minVerticalPadding: 10,
          leading: CircleAvatar(
            radius: 20,
            foregroundImage: widget.receiveRequest.receiverAvatarUrl == null
                ? AssetImage(
                    "assets/images/person.png",
                  )
                : NetworkImage(widget.receiveRequest.receiverAvatarUrl),
          ),
          title: RichText(
            // "${receiveRequest.receiverName} ${S.of(context).registeredItem} ${receiveRequest.itemName} ${S.of(context).withMessage} ${receiveRequest.receiveReason}",
            text: TextSpan(
                text: "${widget.receiveRequest.receiverName}",
                style: Theme.of(context).textTheme.headline3,
                children: [
                  TextSpan(
                    text: " ${S.of(context).registeredItem}",
                    style: DefaultTextStyle.of(context).style,
                  ),
                  TextSpan(
                    text: " ${widget.receiveRequest.itemName}",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  TextSpan(
                    text: " ${S.of(context).withMessage}",
                    style: DefaultTextStyle.of(context).style,
                  ),
                  TextSpan(
                    text: " ${widget.receiveRequest.receiveReason}",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ]),
          ),
          subtitle: Text(
            TimeAgo.parse(widget.receiveRequest.createDate, locale: Localizations.localeOf(context).languageCode),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
    );
  }
}
