import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String _title;
  final String _message;
  final String _acceptButton;
  final String _declineButton;

  ConfirmDialog(
      this._title, this._message, this._acceptButton, this._declineButton);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      contentPadding: EdgeInsets.only(left: 24, top: 10, right: 24),
      buttonPadding: EdgeInsets.symmetric(horizontal: 10),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(_message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(_declineButton),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text(_acceptButton),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
