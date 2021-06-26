import 'package:flutter/material.dart';

class MiniIndicator extends StatelessWidget {
  const MiniIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ),
    );
  }
}
