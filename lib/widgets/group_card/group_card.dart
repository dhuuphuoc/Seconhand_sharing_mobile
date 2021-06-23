import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';

class GroupCard extends StatelessWidget {
  final GroupDetail group;

  GroupCard(this.group);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/group/detail", (route) => route.settings.name == "/group/detail" ? false : true,
              arguments: group.id);
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: CircleAvatar(
                  foregroundImage: AssetImage("assets/images/person.png"),
                  backgroundColor: Theme.of(context).backgroundColor,
                ),
                title: Text(
                  group.groupName,
                  style: Theme.of(context).textTheme.headline3,
                ),
                subtitle: Text(
                  "${TimeAgo.parse(group.createDate, locale: Localizations.localeOf(context).languageCode)}",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  group.groupName,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, bottom: 10),
                child: Text(
                  group.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  group.rules,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Divider(
                height: 3,
                thickness: 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  "Group Test Card",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
