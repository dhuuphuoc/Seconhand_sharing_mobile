import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/member/member.dart';
import 'package:secondhand_sharing/models/user/user_info/user_info.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class UserSearchTab extends StatefulWidget {
  final String keyword;

  UserSearchTab(this.keyword);

  @override
  _EventSearchTabState createState() => _EventSearchTabState();
}

class _EventSearchTabState extends State<UserSearchTab> with AutomaticKeepAliveClientMixin<UserSearchTab> {
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  int _pageSize = 8;
  List<Member> _users = [];
  bool _isLoading = true;
  bool _isEnd = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void didUpdateWidget(covariant UserSearchTab oldWidget) {
    if (oldWidget.keyword != widget.keyword) {
      _isEnd = false;
      _users = [];
      _pageNumber = 1;
      loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> loadData() async {
    if (_isEnd) return;
    setState(() {
      _isLoading = true;
    });
    var users = await UserServices.search(widget.keyword, _pageNumber, _pageSize);
    setState(() {
      if (users.length < _pageSize) {
        _isEnd = true;
      }
      _users.addAll(users);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> listViewWidget = [];

    _users.forEach((user) {
      listViewWidget.add(Card(
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, "/profile", arguments: user.id);
          },
          leading: Avatar(user.avatarUrl, 20),
          title: Text(
            user.fullName,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ));
    });
    listViewWidget.add(SizedBox(height: 5));
    listViewWidget.add(Container(
      height: screenSize.height * 0.1,
      child: Center(
        child: _isLoading
            ? MiniIndicator()
            : _isEnd
                ? Text(S.of(context).end)
                : null,
      ),
    ));

    return _users.isEmpty && !_isLoading
        ? Center(
            child: Text(
              S.of(context).eventNotFound(widget.keyword),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        : NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                _pageNumber++;
                loadData();
              }
              return true;
            },
            child: ListView(
                controller: _scrollController,
                cacheExtent: 5000,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: listViewWidget),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
