import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/authentication_services/authentication_services.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';

class ConfirmEmailScreen extends StatefulWidget {
  @override
  _ConfirmEmailScreenState createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  @override
  void initState() {
    super.initState();
  }

  String _userId;
  String _code;
  bool _isLoading = false;

  void _confirmEmailSubmit() async {
    setState(() {
      _isLoading = true;
    });

    bool result = await AuthenticationService.confirmEmail(ConfirmEmailForm(_userId, _code));

    if (!result) {
      showDialog(
          context: context,
          builder: (context) {
            return NotifyDialog(S.of(context).failed, S.of(context).confirmEmailFail, "OK");
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return NotifyDialog(S.of(context).success, S.of(context).confirmEmailSuccess, "OK");
          }).whenComplete(() {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/login");
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments as Map;
    _userId = data["userId"];
    _code = data["code"];
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
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
                S.of(context).confirmEmail,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                S.of(context).confirmEmailHint,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(
                height: 50,
              ),
              _isLoading ? Align(child: CircularProgressIndicator()) : SizedBox(),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                child: GradientButton(
                  onPress: _confirmEmailSubmit,
                  text: S.of(context).confirm,
                  disabled: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
