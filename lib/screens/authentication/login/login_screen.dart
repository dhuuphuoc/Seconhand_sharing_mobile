import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/login_model/login_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/authentication_services/authentication_services.dart';
import 'package:secondhand_sharing/services/firebase_services/firebase_services.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isLoading = false;

  void _loginSubmit() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _isLoading = true;
    });
    LoginModel loginModel = await AuthenticationService.login(
        LoginForm(_usernameTextController.text, _passwordTextController.text));
    if (loginModel != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", loginModel.accessData.jwToken);
      AccessInfo().token = loginModel.accessData.jwToken;
      AccessInfo().userInfo = loginModel.accessData.userInfo;
      String deviceToken = await FirebaseMessaging.instance.getToken();
      await FirebaseServices.saveTokenToDatabase(deviceToken);
      Navigator.pop(context);
      Navigator.pushNamed(context, "/home");
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return NotifyDialog(S.of(context).failed,
              S.of(context).loginFailedNotification, S.of(context).tryAgain);
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
    // Navigator.pushNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 35),
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
                    child: Image.asset(
                  "assets/images/login_icon.png",
                  isAntiAlias: true,
                )),
                Text(
                  S.of(context).login,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  S.of(context).loginHint,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _usernameTextController,
                  validator: Validator.validateEmail,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: S.of(context).username,
                      suffixIcon: Icon(Icons.email)),
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordTextController,
                  validator: Validator.validatePassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: _loginSubmit,
                  decoration: InputDecoration(
                      hintText: S.of(context).password,
                      suffixIcon: Icon(Icons.lock)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/register");
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Text(
                        S.of(context).registerForFree,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/forgot-password");
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          alignment: Alignment.centerRight),
                      child: Text(
                        "${S.of(context).forgotPassword}?",
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? Align(child: CircularProgressIndicator())
                    : SizedBox(),
                if (_isLoading)
                  SizedBox(
                    height: 15,
                  ),
                Container(
                    width: double.infinity,
                    child: GradientButton(
                      text: S.of(context).login,
                      onPress: _loginSubmit,
                      disabled: _isLoading,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
