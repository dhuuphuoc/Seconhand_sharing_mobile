import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class AddPhoto extends StatelessWidget {
  final onPress;

  AddPhoto({this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 130,
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined),
            SizedBox(height: 5),
            Text(S.of(context).selectPhotos),
          ],
        ),
      ),
    );
  }
}
