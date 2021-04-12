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
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(fit: StackFit.expand, children: [
          ClipRRect(
            child: Image.file(
              image,
              frameBuilder: (BuildContext context, Widget child, int frame,
                  bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded ?? false) {
                  return child;
                }
                return AnimatedOpacity(
                  child: child,
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              },
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              child: Icon(isSelected ? Icons.check_circle : Icons.circle,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).backgroundColor),
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 1.5, color: Theme.of(context).primaryColor)),
            ),
          ),
        ]),
      ),
    );
  }
}
