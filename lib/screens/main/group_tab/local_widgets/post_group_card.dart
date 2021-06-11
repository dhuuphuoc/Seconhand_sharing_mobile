import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class PostGroupCard extends StatelessWidget {
  final Function onPostGroup;

  PostGroupCard(this.onPostGroup);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 10,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                S.of(context).group.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 30,
              child: ElevatedButton(
                onPressed: onPostGroup,
                child: Text(
                  "+ " + S.of(context).createGroup,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
