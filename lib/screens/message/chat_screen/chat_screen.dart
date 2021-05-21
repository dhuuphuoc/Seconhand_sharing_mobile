import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/messages_model/message.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';
import 'package:secondhand_sharing/screens/message/chat_screen/local_widgets/message_box.dart';
import 'package:secondhand_sharing/services/api_services/message_services/message_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _textController = TextEditingController();
  var _scrollController = ScrollController();
  bool _needScroll = false;
  UserInfo _userInfo;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      MessageServices.getMessages(_userInfo.id).then((value) {
        setState(() {
          messages = value.reversed.toList();
          _needScroll = true;
        });
      });
    });
  }

  void scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    _userInfo = ModalRoute.of(context).settings.arguments;
    UserInfo me = AccessInfo().userInfo;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_needScroll) {
        scrollToEnd();
      }
    });
    List<Widget> messageWidgets = [];
    if (messages.isNotEmpty) {
      bool havePrevious;
      bool haveNext;
      for (int i = 0; i < messages.length; i++) {
        Message message = messages[i];
        if (i > 0) {
          havePrevious =
              messages[i - 1].sendFromAccountId == message.sendFromAccountId;
        } else {
          havePrevious = false;
        }
        if (i < messages.length - 1) {
          haveNext =
              messages[i + 1].sendFromAccountId == message.sendFromAccountId;
        } else {
          haveNext = false;
        }
        messageWidgets.add(MessageBox(
          messages[i],
          message.sendFromAccountId == me.id,
          havePrevious
              ? haveNext
                  ? MessageBoxType.middle
                  : MessageBoxType.last
              : haveNext
                  ? MessageBoxType.first
                  : MessageBoxType.single,
        ));
      }
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          _userInfo.fullName,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.circle,
              color: Colors.green,
              size: 15,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: double.infinity,
            color: Color(0xFFDDDDDD),
            child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(children: messageWidgets),
                )),
          )),
          TextField(
              controller: _textController,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "${S.of(context).message}...",
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 20, top: 14, right: 12, bottom: 12),
                suffixIcon: IconButton(
                  splashRadius: 24,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text == "") return;
                    Message message = Message(
                        content: _textController.text.trim(),
                        sendToAccountId: _userInfo.id);
                    MessageServices.sendMessage(message).then((value) {
                      setState(() {
                        messages.add(value);
                        _needScroll = true;
                      });
                    });
                    _textController.text = "";
                  },
                ),
              )),
        ],
      ),
    );
  }
}
