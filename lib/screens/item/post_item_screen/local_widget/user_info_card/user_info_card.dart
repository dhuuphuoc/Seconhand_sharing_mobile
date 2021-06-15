import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';

class UserInfoCard extends StatefulWidget {
  final Function onMapPress;

  UserInfoCard(this.onMapPress);

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            horizontalTitleGap: 10,
            leading: CircleAvatar(
              maxRadius: 22,
              foregroundImage: AccessInfo().userInfo.avatarUrl == null
                  ? AssetImage("assets/images/person.png")
                  : NetworkImage(AccessInfo().userInfo.avatarUrl),
            ),
            title: Text(
              AccessInfo().userInfo.fullName,
              style: Theme.of(context).textTheme.headline3,
            ),
            subtitle: Text(
              AccessInfo().userInfo.email,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            trailing: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.contact_phone_outlined),
              onPressed: () {
                Navigator.of(context).pushNamed("/profile", arguments: AccessInfo().userInfo.id);
              },
            ),
          ),
        ));
  }
}
