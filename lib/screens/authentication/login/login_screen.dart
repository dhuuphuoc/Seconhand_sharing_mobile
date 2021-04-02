import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/authentication_services/authentication_services.dart';
import 'package:secondhand_sharing/ultils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';

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
    int statusCode = await AuthenticationService.login(
        LoginForm(_usernameTextController.text, _passwordTextController.text));
    if (statusCode == 200) {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/home");
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
                  validator: Validator.validateUsername,
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
                  decoration: InputDecoration(
                      hintText: S.of(context).password,
                      suffixIcon: Icon(Icons.lock)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/register");
                      },
                      child: Text(
                        S.of(context).registerForFree,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/forgotPassword");
                      },
                      child: Text(
                        "${S.of(context).forgotPassword}?",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
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
