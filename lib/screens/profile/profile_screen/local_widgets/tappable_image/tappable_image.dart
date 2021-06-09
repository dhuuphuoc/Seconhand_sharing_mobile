import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';

class TappableImage extends StatelessWidget {
  final Function _onPress;
  final ImageData _image;

  TappableImage(this._onPress, this._image);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          child: Image.memory(
            _image.data,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
