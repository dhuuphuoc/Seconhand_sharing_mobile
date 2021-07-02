import 'package:flutter/material.dart';

class GroupAvatar extends StatelessWidget {
  const GroupAvatar(this._avatarUrl, this._radius);
  final String _avatarUrl;
  final double _radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _radius,
      foregroundImage: _avatarUrl == null ? AssetImage("assets/images/group.png") : NetworkImage(_avatarUrl),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
