import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_widget/group_widget.dart';

class PostGroupCard extends StatefulWidget {
  final Function onPostGroup;
  final List<Group> groups;

  PostGroupCard(this.onPostGroup, this.groups);

  @override
  _PostGroupCardState createState() => _PostGroupCardState();
}

class _PostGroupCardState extends State<PostGroupCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 10,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    S.of(context).group.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: widget.onPostGroup,
                      child: Text(
                        "+ " + S.of(context).createGroup,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.groups.map((e) => GroupWidget(e)).toList(),
            ),
          )
        ],
      ),
    );
  }
}
