import 'package:flutter/material.dart';

class NumberBadge extends StatelessWidget {
  final int length;

  NumberBadge(this.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text(
        length.toString(),
        style: TextStyle(color: length > 0 ? Colors.white : Colors.black54),
      ),
      decoration: BoxDecoration(
        color: length > 0 ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
