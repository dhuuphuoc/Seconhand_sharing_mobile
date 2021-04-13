import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';

class ImageView extends StatelessWidget {
  final ImageData image;

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
        child: Image.memory(
          image.data,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
