import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/authentication_services/authentication_services.dart';
import 'package:secondhand_sharing/ultils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _fullNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  bool _isLoading = false;

  void _registerSubmit() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _isLoading = true;
    });
    int statusCode = await AuthenticationService.register(
        RegisterForm(
        _fullNameTextController.text,
        _emailTextController.text,
        _passwordTextController.text)
    );
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
                Text(S.of(context).registerSuccess),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.pushNamed(context, "/");
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
                Text(S.of(context).registerFailedNotification),
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
                Align(child: Image.asset("assets/images/login_icon.png")),
                Text(
                  S.of(context).register,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  S.of(context).registerHint,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _fullNameTextController,
                  validator: (value) {
                    return value.isEmpty
                        ? S.of(context).emptyFullNameError
                        : null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: S.of(context).name,
                    suffixIcon: Icon(
                      Icons.account_circle,
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTextController,
                  validator: Validator.validateEmail,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Email",
                    suffixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _passwordTextController,
                  validator: Validator.validatePassword,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: S.of(context).password,
                    suffixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _confirmPasswordTextController,
                  validator: (value) {
                    return value.isEmpty
                        ? S.of(context).emptyPasswordError
                        : value == _passwordTextController.text
                            ? null
                            : S.of(context).matchPassword;
                  },
                  obscureText: true,
                  onEditingComplete: _registerSubmit,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: S.of(context).confirmPassword,
                    suffixIcon: Icon(
                      Icons.lock,
                    ),
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
                    text: S.of(context).register,
                    onPress: _registerSubmit,
                    disabled: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
