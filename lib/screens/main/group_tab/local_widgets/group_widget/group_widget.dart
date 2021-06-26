import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';

class GroupWidget extends StatelessWidget {
  final Group _group;

  GroupWidget(this._group);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(_group.id);
        Navigator.pushNamed(context, "/group/detail", arguments: _group.id);
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        child: Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                child: _group.avatarURL == null
                    ? Image.asset(
                        "assets/images/group.png",
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        _group.avatarURL,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                width: double.infinity,
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
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              )
            ]),
      ),
      // Container(
      //   height: 100,
      //   width: 100,
      //   margin: EdgeInsets.only(right: 5),
      //   child: Stack(
      //     alignment: AlignmentDirectional.bottomCenter,
      //     fit: StackFit.expand,
      //     children: [
      //       _group.avatarURL == null
      //           ? Image.asset(
      //               "assets/images/group.png",
      //               fit: BoxFit.cover,
      //             )
      //           : Image.network(_group.avatarURL),
      //       Container(
      //         width: 110,
      //         height: 45,
      //         padding: EdgeInsets.symmetric(horizontal: 5),
      //         decoration: BoxDecoration(
      //             gradient: LinearGradient(
      //           begin: Alignment.bottomCenter,
      //           end: Alignment.topCenter,
      //           colors: [
      //             Colors.black87,
      //             Colors.black26,
      //           ],
      //         )),
      //         child: Align(
      //             alignment: Alignment.centerLeft,
      //             child: Text(
      //               _group.groupName,
      //               style: TextStyle(
      //                   color: Colors.white, fontWeight: FontWeight.bold),
      //             )),
      //       )
      //     ],
      //   ),
    );
  }
}
