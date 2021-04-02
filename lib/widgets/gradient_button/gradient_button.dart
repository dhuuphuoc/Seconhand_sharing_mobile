import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final Function onPress;
  final String text;
  final bool disabled;

  GradientButton({@required this.onPress, this.text, this.disabled = false});

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return ElevatedButton(
        clipBehavior: Clip.antiAlias,
        onPressed: widget.disabled ? null : widget.onPress,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Theme.of(context).disabledColor),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          elevation: MaterialStateProperty.all<double>(10),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: widget.disabled
            ? Text(widget.text)
            : Ink(
                decoration: BoxDecoration(
                    gradient: widget.disabled
                        ? null
                        : LinearGradient(colors: [
                            primary,
                            Color(primary.value + 0xFF8F4805),
                          ])),
                child: Container(
                  width: double.infinity,
                  constraints:
                      const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                  alignment: Alignment.center,
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                  ),
                ),
              ));
  }
}
