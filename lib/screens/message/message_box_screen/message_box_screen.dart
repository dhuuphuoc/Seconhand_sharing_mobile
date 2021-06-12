import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/messages_model/user_message.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';
import 'package:secondhand_sharing/services/api_services/message_services/message_services.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';

class MessageBoxScreen extends StatefulWidget {
  const MessageBoxScreen({Key key}) : super(key: key);

  @override
  _MessageBoxScreenState createState() => _MessageBoxScreenState();
}

class _MessageBoxScreenState extends State<MessageBoxScreen> {
  bool _isLoading = true;
  List<UserMessage> _messages = [];
  bool _isEnd = false;
  int _pageNumber = 1;
  int _pageSize = 20;
  ScrollController _scrollController = ScrollController();
  StreamSubscription<RemoteMessage> _subscription;
  @override
  void initState() {
    fetchRecentMessages();
    _scrollController.addListener(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
        if (!_isEnd && !_isLoading) {
          _pageNumber++;
          fetchRecentMessages();
        }
      }
    });
    _subscription = FirebaseMessaging.onMessage.listen((message) {
      if (message.data["type"] != "1" && message.data["type"] != "5") return;
      UserMessage newMessage = UserMessage.fromJson(jsonDecode(message.data["message"]));
      int index = _messages.indexWhere((element) {
        if (element.sendFromAccountId == newMessage.sendFromAccountId ||
            element.sendToAccountId == newMessage.sendFromAccountId) {
          return true;
        }
        return false;
      });
      setState(() {
        _messages[index] = newMessage;
        var temp = _messages[0];
        _messages[0] = _messages[index];
        _messages[index] = temp;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> fetchRecentMessages() async {
    setState(() {
      _isLoading = true;
    });
    var messages = await MessageServices.getRecentMessages(_pageNumber, _pageSize);

    setState(() {
      _messages.addAll(messages);
      if (messages.length < _pageSize) {
        _isEnd = true;
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> widgets = [];

    for (int i = 0; i < _messages.length; i++) {
      var message = _messages[i];
      bool isMy = message.sendFromAccountId == AccessInfo().userInfo.id;
      widgets.add(Card(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: ListTile(
          onTap: () async {
            UserInfo userInfo;
            if (isMy) {
              userInfo = UserInfo(id: message.sendToAccountId, fullName: message.sendToAccountName);
            } else {
              userInfo = UserInfo(id: message.sendFromAccountId, fullName: message.sendFromAccountName);
            }
            Navigator.pushNamedAndRemoveUntil(
                    context, "/chat", (route) => route.settings.name == "/chat" ? false : true,
                    arguments: userInfo)
                .then((value) {
              if (value != null)
                setState(() {
                  _messages[i] = value;
                  var temp = _messages.first;
                  _messages[0] = _messages[i];
                  _messages[i] = temp;
                });
            });
          },
          leading: CircleAvatar(
            radius: 25,
            foregroundImage: isMy && message.sendToAccountAvatarUrl == null ||
                    message.sendFromAccountId != AccessInfo().userInfo.id && message.sendFromAccountAvatarUrl == null
                ? AssetImage(
                    "assets/images/person.png",
                  )
                : NetworkImage(isMy ? message.sendToAccountAvatarUrl : message.sendFromAccountAvatarUrl),
            backgroundImage: AssetImage(
              "assets/images/person.png",
            ),
          ),
          title: Text(
            isMy ? message.sendToAccountName : message.sendFromAccountName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            "${isMy ? "${S.of(context).youUpperCase}: " : ""}${message.content}",
            style: Theme.of(context).textTheme.bodyText2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            TimeAgo.parse(message.sendDate, locale: Localizations.localeOf(context).languageCode),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ));
    }
    widgets.add(Container(
      height: _isEnd ? 0 : screenSize.height * 0.2,
      child: Center(
        child: _isLoading ? CircularProgressIndicator() : Container(),
      ),
    ));
    if (_isEnd) {
      widgets.add(Container(
        height: screenSize.height * 0.2,
        child: Center(
          child: Text(
            S.of(context).messagesEnded,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).messageBox,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
      ),
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is OverscrollNotification) {
            if (notification.overscroll > 0) {
              if (!_isEnd && !_isLoading) {
                _pageNumber++;
                fetchRecentMessages();
              }
            }
          }

          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _pageNumber = 1;
            _messages = [];
            _isEnd = false;
            fetchRecentMessages();
          },
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(10),
            controller: _scrollController,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
