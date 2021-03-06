import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';

class SelectiveImageView extends StatelessWidget {
  final Function onPress;
  final bool isSelected;
  final ImageData image;

  SelectiveImageView({@required this.onPress, this.isSelected = false, @required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(10)),
        child: Stack(fit: StackFit.expand, children: [
          ClipRRect(
            child: Image.memory(
              image.data,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              child: Icon(isSelected ? Icons.check_circle : Icons.circle,
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor),
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 1.5, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
