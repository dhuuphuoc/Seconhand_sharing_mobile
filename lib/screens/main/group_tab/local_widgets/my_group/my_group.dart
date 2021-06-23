import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_widget/group_widget.dart';

class MyGroup extends StatefulWidget {
  final List<Group> groups;

  MyGroup(this.groups);

  @override
  _MyGroupState createState() => _MyGroupState();
}

class _MyGroupState extends State<MyGroup> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                S.of(context).joinedGroup.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
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
