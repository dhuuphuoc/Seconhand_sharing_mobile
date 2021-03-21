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

  void onChange(String input){

  }

  final _formKey = GlobalKey<FormState>();

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
                TextField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey)),
                    hintText: "-   -   -   -",
                    filled: true,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  // maxLength: 4,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: GradientButton(() {
                    Navigator.of(context).pushNamed("/");
                  }, S.of(context).confirm),
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
