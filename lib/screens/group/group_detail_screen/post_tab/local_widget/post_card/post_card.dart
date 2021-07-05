import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/post/post.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/images_view/images_view.dart';

class PostCard extends StatelessWidget {
  final Post _post;

  PostCard(this._post);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Avatar(_post.avatarUrl, 20),
            title: Text(
              _post.postByAccountName,
              style: Theme.of(context).textTheme.headline3,
            ),
            subtitle: Text(
              "${TimeAgo.parse(_post.postTime, locale: Localizations.localeOf(context).languageCode)}",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(_post.content),
          ),
          if (_post.imageUrl.isNotEmpty) ...{
            SizedBox(
              height: 20,
            ),
            if (_post.imageUrl.isNotEmpty)
              ImagesView(
                _post.imageUrl,
              ),
            SizedBox(
              height: 10,
            ),
          },
          Divider(
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {},
                child: Container(
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mode_comment_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Text(S.of(context).comment),
                    ],
                  ),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
