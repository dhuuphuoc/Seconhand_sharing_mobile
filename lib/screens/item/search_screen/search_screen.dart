import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/screens/item/search_screen/event_search_tab/event_search_tab.dart';
import 'package:secondhand_sharing/screens/item/search_screen/group_search_tab/group_search_tab.dart';
import 'package:secondhand_sharing/screens/item/search_screen/item_search_tab/item_search_tab.dart';
import 'package:secondhand_sharing/screens/item/search_screen/user_search_tab/user_search_tab.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _searchTextEditingController = TextEditingController();
  String _keyword = "";
  Timer _timer;
  bool _isCloseable = false;
  bool _isEnd = false;

  @override
  void initState() {
    super.initState();
  }

  void clear() {
    _searchTextEditingController.clear();
    setState(() {
      _isCloseable = false;
    });
  }

  void onChanged(String value) {
    setState(() {
      _isCloseable = value.isNotEmpty;
    });
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 500), query);
  }

  Future<void> query() async {
    _timer?.cancel();
    setState(() {
      _keyword = _searchTextEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 56, bottom: 8, right: 20, top: 0),
            title: Container(
              margin: EdgeInsets.only(top: 10, bottom: kToolbarHeight - 10),
              decoration:
                  BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _searchTextEditingController,
                onChanged: onChanged,
                onEditingComplete: query,
                textInputAction: TextInputAction.search,
                cursorHeight: 20,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 14, top: 5.5),
                  border: InputBorder.none,
                  hintText: S.of(context).search,
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    onPressed: _isCloseable ? clear : null,
                    icon: Icon(Icons.close, color: _isCloseable ? Colors.black54 : Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: S.of(context).item,
              ),
              Tab(text: S.of(context).user),
              Tab(
                text: S.of(context).group,
              ),
              Tab(
                text: S.of(context).event,
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ItemSearchTab(_keyword, -1),
            UserSearchTab(_keyword),
            GroupSearchTab(_keyword),
            EventSearchTab(_keyword),
          ],
        ),
      ),
    );
  }
}
