import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class GroupDetailScreen extends StatefulWidget {
  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).detail,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 15),
            ),
          )
        ],
      ),
      body: Container(

      ),
    );
  }
}
