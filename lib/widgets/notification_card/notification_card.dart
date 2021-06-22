import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final IconData _icon;
  final String _notification;

  NotificationCard(this._icon, this._notification);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Icon(
              _icon,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _notification,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
