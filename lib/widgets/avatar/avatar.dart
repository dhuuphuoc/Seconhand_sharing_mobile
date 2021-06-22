import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(this._avatarUrl, this._radius);
  final String _avatarUrl;
  final double _radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _radius,
      foregroundImage: _avatarUrl == null ? AssetImage("assets/images/person.png") : NetworkImage(_avatarUrl),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
