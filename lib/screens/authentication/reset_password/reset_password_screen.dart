import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void initState() {
    super.initState();
  }
  String _digit = "-   -   -   -";
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  void onSubmit(String input) {
    input = input.replaceAll(" ", "");
  }

  void onChanged(RawKeyEvent input) {
    if(input.isKeyPressed(LogicalKeyboardKey.backspace)) {
      for(int i = _digit.length - 1; i >= 0; i--) {
        print(_digit[i]);
        if(int.tryParse(_digit[i]) != null) {
          print(_digit[i]);
          _digit = _digit.replaceFirst(_digit[i], "-", i);
          setState(() {
            _textEditingController.text = _digit;
          });
          return;
        }
      }
    }
    if(input.character != null) {
      _digit = _digit.replaceFirst("-", input.character);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Align(
                  child: Image.asset("assets/images/login_icon.png"),
                ),
                Text(
                  S.of(context).verifyCode,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  S.of(context).verifyCodeHint,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 10,
                ),
                RawKeyboardListener(
                  focusNode: _focusNode,
                  onKey: onChanged,
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      hintText: "-   -   -   -",
                      counterText: "",
                      filled: true,
                    ),
                    showCursor: false,
                    onChanged: (digit) {
                      setState(() {
                        _textEditingController.text = _digit;
                      });
                    },
                    onFieldSubmitted: onSubmit,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: GradientButton(onPress: () {
                  },text: S.of(context).confirm),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        S.of(context).sendCode,
                        style: TextStyle(
                            color: Color(0xFF0E88FA),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        S.of(context).anotherEmail,
                        style: TextStyle(color: Color(0xFF0E88FA)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
