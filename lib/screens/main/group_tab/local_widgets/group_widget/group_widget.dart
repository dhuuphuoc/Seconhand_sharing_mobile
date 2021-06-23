import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';

class GroupWidget extends StatelessWidget {
  final Group _group;

  GroupWidget(this._group);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/group/detail", arguments: _group.id);
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image.asset(
              "assets/images/group.png",
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
            Container(
              width: 110,
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black87,
                  Colors.black26,
                ],
              )),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _group.groupName,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
