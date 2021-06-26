import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/message/user_message.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user/user_info/user_info.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/message_services/message_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({Key key}) : super(key: key);

  @override
  _MessageTabState createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> with AutomaticKeepAliveClientMixin {
  List<UserMessage> _messages = [];
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  int _pageSize = 10;
  bool _isLoading = true;
  bool _isEnd = false;
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

  void absorbScrollBehaviour(double scrolled) {
    NestedScrollView nestedScrollView = Keys.nestedScrollViewKey.currentWidget;
    ScrollController primaryScrollController = nestedScrollView.controller;
    primaryScrollController.jumpTo(primaryScrollController.offset + scrolled);
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
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> widgets = [];
    widgets.add(Container(
      padding: EdgeInsets.only(left: 18, right: 5),
      height: screenSize.height * 0.07,
      color: Theme.of(context).backgroundColor,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          S.of(context).messageBox,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    ));
    widgets.add(SizedBox(height: 5));
    for (int i = 0; i < _messages.length; i++) {
      var message = _messages[i];
      bool isMy = message.sendFromAccountId == AccessInfo().userInfo.id;
      widgets.add(Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          leading: Avatar(isMy ? message.sendToAccountAvatarUrl : message.sendFromAccountAvatarUrl, 25),
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
        child: _isLoading ? MiniIndicator() : Container(),
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
    return NotificationListener(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          absorbScrollBehaviour(notification.overscroll);
          if (notification.overscroll > 0) {
            if (!_isEnd && !_isLoading) {
              _pageNumber++;
              fetchRecentMessages();
            }
          }
        }
        if (notification is ScrollUpdateNotification) {
          absorbScrollBehaviour(notification.scrollDelta);
        }

        return true;
      },
      child: RefreshIndicator(
        edgeOffset: screenSize.height * 0.02,
        onRefresh: () async {
          _messages = [];
          _isEnd = false;
          _pageNumber = 1;

          await fetchRecentMessages();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          cacheExtent: double.infinity,
          slivers: [
            SliverOverlapInjector(
              // This is the flip side of the SliverOverlapAbsorber
              // above.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverList(delegate: SliverChildListDelegate(widgets)),
          ],
          // ListView(
          //   padding: EdgeInsets.only(bottom: 10),
          //   controller: _scrollController,
          //   children: listViewWidgets,
          //   // ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
