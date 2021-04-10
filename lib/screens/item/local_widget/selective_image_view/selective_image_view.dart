import 'dart:io';

import 'package:flutter/material.dart';

class SelectiveImageView extends StatelessWidget {
  final Function onPress;
  final bool isSelected;
  final File image;

  SelectiveImageView(
      {@required this.onPress, this.isSelected = false, @required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        constraints: BoxConstraints(minWidth: 120),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(fit: StackFit.expand, children: [
          ClipRRect(
            child: Image.file(
              image,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          Container(
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(isSelected ? Icons.check_circle : Icons.circle,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).backgroundColor),
            ),
            margin: EdgeInsets.all(5),
          ),
        ]),
      ),
    );
  }
}