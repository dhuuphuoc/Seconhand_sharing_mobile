import 'package:flutter/material.dart';

class NotifyDialog extends StatelessWidget {
  final String title;
  final String message;
  final String button;

  NotifyDialog(this.title, this.message, this.button);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text(title),
      contentPadding: EdgeInsets.only(left: 24, top: 10, right: 24, bottom: 0),
      buttonPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.only(right: 10, bottom: 10),
      insetPadding: EdgeInsets.all(25),
      content: Container(
        width: screenSize.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(button),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
