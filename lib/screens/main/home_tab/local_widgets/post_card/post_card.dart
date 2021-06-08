import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';

class PostCard extends StatelessWidget {
  final Function onPostItem;

  PostCard(this.onPostItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 10,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 7),
              child: CircleAvatar(
                radius: 30,
                foregroundImage: AccessInfo().userInfo.avatarUrl == null
                    ? AssetImage("assets/images/person.png")
                    : NetworkImage(AccessInfo().userInfo.avatarUrl),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 38,
              child: ElevatedButton(
                onPressed: onPostItem,
                child: Text(
                  S.of(context).postItem,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
