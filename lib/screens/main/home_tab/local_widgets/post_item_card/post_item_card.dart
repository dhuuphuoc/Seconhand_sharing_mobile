import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';

class PostItemCard extends StatelessWidget {
  final Function onPostItem;

  PostItemCard(this.onPostItem);

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
              child: Avatar(AccessInfo().userInfo.avatarUrl, 26),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 38,
              child: ElevatedButton(
                onPressed: onPostItem,
                child: Text(
                  S.of(context).donate,
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
