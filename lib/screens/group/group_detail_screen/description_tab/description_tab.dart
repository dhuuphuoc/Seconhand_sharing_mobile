import 'package:flutter/material.dart';

class DescriptionTab extends StatelessWidget {
  final String _description;

  DescriptionTab(this._description);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Text(_description),
        ),
      ),
    );
  }
}
