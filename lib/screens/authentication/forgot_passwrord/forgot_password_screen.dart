import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/authentication_services/authentication_services.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  bool _isLoading = false;

  void _forgotPasswordSubmit() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _isLoading = true;
    });
    int statusCode = await AuthenticationService.forgotPassword(
        ForgotPasswordForm(_emailTextController.text));
    print(statusCode);
    if (statusCode == 200) {
      _showDialogSuccess();
    } else {
      _showDialogFail();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showDialogSuccess() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          title: Text(S.of(context).success),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S.of(context).checkMailForgotPassword),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.pushNamed(context, "/resetPassword");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogFail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          title: Text(S.of(context).failed),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S.of(context).unexistEmail),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).tryAgain),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    S.of(context).forgotPassword,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    S.of(context).forgotPasswordHint,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTextController,
                    validator: Validator.validateEmail,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _forgotPasswordSubmit,
                    decoration: InputDecoration(
                      hintText: "Email",
                      suffixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _isLoading
                      ? Align(child: CircularProgressIndicator())
                      : SizedBox(),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    child: GradientButton(
                      onPress: _forgotPasswordSubmit,
                      text: S.of(context).continueButton,
                      disabled: _isLoading,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
