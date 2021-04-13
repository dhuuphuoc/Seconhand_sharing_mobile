import 'dart:io';

import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final File image;

  ImageView({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 130,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        child: Image.file(
          image,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
