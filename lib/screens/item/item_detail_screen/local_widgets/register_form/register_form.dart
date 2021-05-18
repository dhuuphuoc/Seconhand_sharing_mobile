import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/receive_services/receive_services.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _textController = TextEditingController();
  String _errorText;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int itemId = ModalRoute.of(context).settings.arguments;
    return AlertDialog(
      title: Text(S.of(context).registerToReceive),
      insetPadding: EdgeInsets.all(15),
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: EdgeInsets.all(10),
      content: Container(
        width: screenSize.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: InputDecoration(
                  hintText: "${S.of(context).message}...",
                  labelText: S.of(context).message,
                  errorText: _errorText),
            ),
            SizedBox(
              height: 20,
            ),
            if (_isLoading)
              Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_textController.text == "") {
                      setState(() {
                        _errorText = S.of(context).messageEmptyError;
                        _isLoading = false;
                      });
                      return;
                    }
                    var result = await ReceiveServices.registerToReceive(
                        itemId, _textController.text);
                    Navigator.pop(context, result);
                    setState(() {
                      _isLoading = false;
                    });
                  },
            child: Text(S.of(context).register))
      ],
    );
  }
}
