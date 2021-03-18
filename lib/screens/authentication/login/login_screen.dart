import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
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
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: "Email", suffixIcon: Icon(Icons.email)),
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
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
                      onTap: () {},
                      child: Text(
                        "${S.of(context).forgotPassword}?",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: double.infinity,
                    child: GradientButton(() {
                      Navigator.pushNamed(context, "/home");
                    }, S.of(context).login))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
