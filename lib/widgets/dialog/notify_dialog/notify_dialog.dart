import 'package:flutter/material.dart';

class NotifyDialog extends StatelessWidget {
  final String title;
  final String message;
  final String button;

  NotifyDialog(this.title, this.message, this.button);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      contentPadding: EdgeInsets.only(left: 24, top: 10, right: 24),
      buttonPadding: EdgeInsets.symmetric(horizontal: 20),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message),
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
