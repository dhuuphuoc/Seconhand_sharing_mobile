import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/contact_model/contact.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDialog extends StatefulWidget {
  final int _itemId;

  ContactDialog(this._itemId);

  @override
  _ContactDialogState createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  Contact _contact;
  bool _isLoading = true;
  bool _isDenied = false;

  @override
  void initState() {
    ItemServices.getOwnerContact(widget._itemId).then((value) {
      if (value != null) {
        setState(() {
          _contact = value;
        });
      } else {
        setState(() {
          _isDenied = true;
        });
      }
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 24, top: 10, right: 24, bottom: 0),
      buttonPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.only(right: 10, bottom: 10),
      insetPadding: EdgeInsets.all(25),
      title: Text(S.of(context).contact),
      content: Container(
        width: screenSize.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading)
              Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: CircularProgressIndicator()),
            if (!_isLoading && _isDenied)
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                title: Text(S.of(context).contactDenied),
              ),
            if (!_isLoading && !_isDenied)
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(_contact.email),
                trailing: IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    await canLaunch("mailto:${_contact.email}?subject=&body=")
                        ? await launch(
                            "mailto:${_contact.email}?subject=&body=")
                        : throw 'Could not launch mailto:${_contact.email}?subject=&body=';
                  },
                ),
              ),
            if (!_isLoading && !_isDenied)
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                    _contact.phoneNumber == null ? "" : _contact.phoneNumber),
                trailing: IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    await canLaunch("tel:${_contact.phoneNumber}")
                        ? await launch("tel:${_contact.phoneNumber}")
                        : throw "Could not launch tel:${_contact.phoneNumber}";
                  },
                ),
              )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(S.of(context).close))
      ],
    );
  }
}
