import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/authentication_services/authentication_services.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';

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
    int statusCode = await AuthenticationService.forgotPassword(ForgotPasswordForm(_emailTextController.text));

    if (statusCode == 200) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return NotifyDialog(S.of(context).success, S.of(context).checkMailForgotPassword, "OK");
        },
      ).whenComplete(() {
        Navigator.pop(context);
      });
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return NotifyDialog(S.of(context).failed, S.of(context).notExistEmail, S.of(context).tryAgain);
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
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
                  _isLoading ? Align(child: CircularProgressIndicator()) : SizedBox(),
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
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
