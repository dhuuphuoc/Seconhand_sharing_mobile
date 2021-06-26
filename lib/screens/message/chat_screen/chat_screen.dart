import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/message/user_message.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user/user_info/user_info.dart';

import 'package:secondhand_sharing/screens/application/application.dart';
import 'package:secondhand_sharing/screens/message/chat_screen/local_widgets/message_box.dart';
import 'package:secondhand_sharing/services/api_services/message_services/message_services.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _textController = TextEditingController();
  var _scrollController;
  bool _isLoading = true;
  int _pageNumber = 1;
  int _pageSize = 20;
  bool _isBottomStick = true;
  UserInfo _userInfo;
  List<UserMessage> messages = [];
  StreamSubscription<RemoteMessage> _subscription;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Application().chattingWithUserId = _userInfo.id;
      _scrollController = ScrollController();
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          loadMoreMessages();
        }
      });
      MessageServices.getMessages(_userInfo.id, _pageNumber, _pageSize).then((value) {
        setState(() {
          messages = value.reversed.toList();
          _isLoading = false;
        });
        _subscription = FirebaseMessaging.onMessage.listen((message) {
          if (message.data["type"] != "1" && message.data["type"] != "5") return;
          UserMessage newMessage = UserMessage.fromJson(jsonDecode(message.data["message"]));
          if (newMessage.sendFromAccountId == _userInfo.id) {
            setState(() {
              messages.add(newMessage);
            });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
    Application().chattingWithUserId = null;
  }

  void loadMoreMessages() {
    _pageNumber++;
    MessageServices.getMessages(_userInfo.id, _pageNumber, _pageSize).then((value) {
      setState(() {
        messages.insertAll(0, value.reversed.toList());
        _isBottomStick = false;
      });
    });
  }

  void scrollToEnd() {
    _scrollController.animateTo(
      0.0,
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
      if (_isBottomStick && !_isLoading) {
        scrollToEnd();
      }
    });
    if (messages.isNotEmpty) {
      bool havePrevious;
      bool haveNext;
      for (int i = 0; i < messages.length; i++) {
        UserMessage message = messages[i];
        if (i > 0) {
          havePrevious = messages[i - 1].sendFromAccountId == message.sendFromAccountId;
        } else {
          havePrevious = false;
        }
        if (i < messages.length - 1) {
          haveNext = messages[i + 1].sendFromAccountId == message.sendFromAccountId;
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
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: double.infinity,
            color: Color(0xFFDDDDDD),
            child: _isLoading
                ? Center(child: MiniIndicator())
                : SingleChildScrollView(
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
                contentPadding: EdgeInsets.only(left: 20, top: 14, right: 12, bottom: 12),
                suffixIcon: IconButton(
                  splashRadius: 24,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text == "") return;
                    UserMessage message =
                        UserMessage(content: _textController.text.trim(), sendToAccountId: _userInfo.id);
                    MessageServices.sendMessage(message).then((value) {
                      setState(() {
                        if (value != null) {
                          messages.add(value);
                          _isBottomStick = true;
                        }
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
