import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';

class ImageView extends StatelessWidget {
  final ImageData image;
  final Function _onRemove;

  ImageView(this.image, this._onRemove);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 130,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(
              image.data,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: _onRemove,
                child: Container(
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).backgroundColor,
                    size: 18,
                  ),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(3),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100), color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
