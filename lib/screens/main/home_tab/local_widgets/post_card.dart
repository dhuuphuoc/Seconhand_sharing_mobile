import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class PostCard extends StatelessWidget {
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
                maxRadius: 25,
                child: Image.asset(
                  "assets/images/person.png",
                  height: 60,
                  fit: BoxFit.fill,
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 38,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/postItem");
                },
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
