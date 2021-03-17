import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Function onPress;
  final String text;

  GradientButton(this.onPress, this.text);

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return ElevatedButton(
        clipBehavior: Clip.antiAlias,
        onPressed: onPress,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          elevation: MaterialStateProperty.all<double>(10),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            primary,
            Color(primary.value + 0xFF8F4805),
          ])),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
