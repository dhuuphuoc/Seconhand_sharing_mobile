import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/message/user_message.dart';

enum MessageBoxType { single, first, middle, last }

class MessageBox extends StatelessWidget {
  final bool _isMy;
  final UserMessage _message;
  final MessageBoxType _type;
  MessageBox(this._message, this._isMy, this._type);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: _isMy ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        margin: EdgeInsets.only(
            left: _isMy ? screenSize.width * 0.4 : 0, top: 3, right: !_isMy ? screenSize.width * 0.4 : 0),
        decoration: BoxDecoration(
          color: _isMy ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: !_isMy && (_type == MessageBoxType.last || _type == MessageBoxType.middle)
                ? Radius.circular(5)
                : Radius.circular(20),
            bottomLeft: !_isMy && (_type == MessageBoxType.first || _type == MessageBoxType.middle)
                ? Radius.circular(5)
                : Radius.circular(20),
            topRight: _isMy && (_type == MessageBoxType.last || _type == MessageBoxType.middle)
                ? Radius.circular(5)
                : Radius.circular(20),
            bottomRight: _isMy && (_type == MessageBoxType.first || _type == MessageBoxType.middle)
                ? Radius.circular(5)
                : Radius.circular(20),
          ),
        ),
        child: Text(
          _message.content,
          style: TextStyle(color: _isMy ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
