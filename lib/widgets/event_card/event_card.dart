import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_sharing/models/group_event/group_event.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_avatar/group_avatar.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/utils/time_remainder/time_remainder.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class EventCard extends StatelessWidget {
  final GroupEvent _event;

  EventCard(this._event);

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat("dd/MM/yyyy");
    String timeReminder = TimeRemainder.parse(_event.endDate, context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/event/detail", arguments: _event.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(90),
                    onTap: () {
                      Navigator.pushNamed(context, "/group/detail", arguments: _event.groupId);
                    },
                    child: GroupAvatar(_event.groupAvatar, 28),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _event.groupName,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          "${TimeAgo.parse(_event.startDate, locale: Localizations.localeOf(context).languageCode)}",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        timeReminder == null ? S.of(context).eventEnded : "${S.of(context).remaining}: $timeReminder",
                        style: TextStyle(
                            color:
                                timeReminder == null ? Theme.of(context).errorColor : DefaultTextStyle.of(context).style.color),
                      ),
                      Text(""),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Text(
                _event.eventName,
                style: Theme.of(context).textTheme.headline2,
              ),
              ListTile(
                leading: Icon(
                  AppIcons.calendar,
                  color: Color(0xFFEB2626),
                ),
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.only(),
                title: Text("${dateFormat.format(_event.startDate)} - ${dateFormat.format(_event.endDate)}"),
              ),
              Text(_event.content),
              SizedBox(height: 10),
              if (timeReminder != null)
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/post-item", arguments: _event);
                        },
                        child: Text(S.of(context).donate)))
            ],
          ),
        ),
      ),
    );
  }
}
