import 'package:flutter/material.dart';
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
  int _pageSize = 10;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    fetchRecentMessages();
    _scrollController.addListener(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
        _pageNumber++;
        fetchRecentMessages();
      }
    });
    super.initState();
  }

  Future<void> fetchRecentMessages() async {
    setState(() {
      _isLoading = true;
    });

    var messages = await MessageServices.getRecentMessages(_pageNumber, _pageSize);
    if (messages.isEmpty) {
      setState(() {
        _isEnd = true;
      });
    } else {
      setState(() {
        _messages.addAll(messages);
      });
    }
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
      widgets.add(Card(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: ListTile(
          onTap: () async {
            UserInfo userInfo;
            if (AccessInfo().userInfo.id == message.sendFromAccountId) {
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
            foregroundImage: AssetImage(
              "assets/images/person.png",
            ),
          ),
          title: Text(
            AccessInfo().userInfo.id == message.sendFromAccountId
                ? message.sendToAccountName
                : message.sendFromAccountName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            "${AccessInfo().userInfo.id == message.sendFromAccountId ? "${S.of(context).youUpperCase}: " : ""}${message.content}",
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
    if (_isLoading) {
      widgets.add(Container(
        height: screenSize.height * 0.2,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    }
    if (_isEnd) {
      widgets.add(Container(
        height: screenSize.height * 0.2,
        child: Center(
          child: Text(
            S.of(context).emptyNotification,
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          controller: _scrollController,
          children: widgets,
        ),
      ),
    );
  }
}
