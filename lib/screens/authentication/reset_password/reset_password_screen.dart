import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/reset_password_model/reset_password_model.dart';
import 'package:secondhand_sharing/services/api_services/authentication_services/authentication_services.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  bool _isLoading = false;
  String _code = "";

  void _resetPasswordSubmit() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _isLoading = true;
    });
    print(_code);
    ResetPasswordModel resetPasswordModel =
        await AuthenticationService.resetPassword(ResetPasswordForm(
            _emailTextController.text,
            _code,
            _passwordTextController.text,
            _confirmPasswordTextController.text));
    if (resetPasswordModel != null) {
      showDialog(
          context: context,
          builder: (context) {
            return NotifyDialog(S.of(context).success,
                S.of(context).resetPasswordSuccess, "OK");
          }).whenComplete(() {
        Navigator.pop(context);
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return NotifyDialog(
                S.of(context).failed, S.of(context).resetPasswordFailed, "OK");
          });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_code != null) {
      _code = ModalRoute.of(context).settings.arguments;
    }
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
                  S.of(context).resetPassword,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  S.of(context).resetPasswordHint,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _emailTextController,
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
                    onPress: _resetPasswordSubmit,
                    text: S.of(context).confirm,
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
