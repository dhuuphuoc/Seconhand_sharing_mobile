import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class ContactDialog extends StatelessWidget {
  final String _email;
  final String _phoneNumber;

  ContactDialog(this._email, this._phoneNumber);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 24, top: 10, right: 24, bottom: 10),
      insetPadding: EdgeInsets.all(25),
      title: Text(S.of(context).contact),
      content: Container(
        width: screenSize.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(_email),
              trailing: IconButton(
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {},
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(_phoneNumber),
              trailing: IconButton(
                icon: Icon(
                  Icons.call,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
