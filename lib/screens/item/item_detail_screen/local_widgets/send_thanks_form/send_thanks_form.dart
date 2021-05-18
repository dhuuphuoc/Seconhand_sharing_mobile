import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/receive_services/receive_services.dart';

class SendThanksForm extends StatefulWidget {
  const SendThanksForm({Key key}) : super(key: key);

  @override
  _SendThanksFormState createState() => _SendThanksFormState();
}

class _SendThanksFormState extends State<SendThanksForm> {
  var _textController = TextEditingController(text: S.current.thanks);
  String _errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int requestId = ModalRoute.of(context).settings.arguments;
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
              autofocus: true,
              controller: _textController,
              maxLines: 3,
              decoration: InputDecoration(
                  hintText: "${S.of(context).thanksMessage}...",
                  labelText: S.of(context).thanksMessage,
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
                    var result = await ReceiveServices.sendThanks(
                        requestId, _textController.text);
                    print(result);
                    Navigator.pop(context, result);
                    setState(() {
                      _isLoading = false;
                    });
                  },
            child: Text(S.of(context).send))
      ],
    );
  }
}
