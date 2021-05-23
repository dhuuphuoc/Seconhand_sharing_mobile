import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';
import 'package:secondhand_sharing/screens/message/chat_screen/local_widgets/message_box.dart';
import 'package:secondhand_sharing/services/api_services/message_services/message_services.dart';
import 'package:secondhand_sharing/services/firebase_services/firebase_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _textController = TextEditingController();
  var _scrollController = ScrollController();
  int page = 1;
  bool _isBottomStick = true;
  UserInfo _userInfo;
  List<UserMessage> messages = [];
  StreamSubscription<RemoteMessage> _subscription;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseServices.chattingWithUserId = _userInfo.id;
      MessageServices.getMessages(_userInfo.id, page).then((value) {
        setState(() {
          messages = value.reversed.toList();
        });
        _subscription = FirebaseMessaging.onMessage.listen((message) {
          print(message.data);
          UserMessage newMessage =
              UserMessage.fromJson(jsonDecode(message.data["value"]));
          print(newMessage.content);
          if (newMessage.sendFromAccountId == _userInfo.id) {
            setState(() {
              messages.add(newMessage);
            });
          }
        });
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        loadMoreMessages();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
    FirebaseServices.chattingWithUserId = null;
  }

  void loadMoreMessages() {
    page++;
    MessageServices.getMessages(_userInfo.id, page).then((value) {
      setState(() {
        messages.insertAll(0, value.reversed.toList());
        _isBottomStick = false;
      });
    });
  }

  void scrollToEnd() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    _userInfo = ModalRoute.of(context).settings.arguments;
    UserInfo me = AccessInfo().userInfo;
    List<Widget> messageWidgets = [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_isBottomStick) {
        scrollToEnd();
      }
    });
    if (messages.isNotEmpty) {
      bool havePrevious;
      bool haveNext;
      for (int i = 0; i < messages.length; i++) {
        UserMessage message = messages[i];
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
                reverse: true,
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
              autofocus: true,
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
                    UserMessage message = UserMessage(
                        content: _textController.text.trim(),
                        sendToAccountId: _userInfo.id);
                    MessageServices.sendMessage(message).then((value) {
                      setState(() {
                        messages.add(value);
                        _isBottomStick = true;
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
