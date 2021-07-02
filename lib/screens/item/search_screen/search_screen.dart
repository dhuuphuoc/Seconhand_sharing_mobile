import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item/item.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _searchTextEditingController = TextEditingController();
  int _pageSize = 8;
  int _pageNumber = 1;
  bool _isSearching = false;
  bool _isLoadingMore = false;
  Timer _timer;
  List<Item> _items = [];
  bool _isCloseable = false;
  bool _isNotFound = false;
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
    setState(() {
      _isSearching = true;
    });
    _items = [];
    _pageNumber = 1;
    _isEnd = false;
    var items = await ItemServices.getItems(-1, _searchTextEditingController.text, _pageNumber, _pageSize);
    setState(() {
      if (items.isNotEmpty) {
        _items.addAll(items);
      }
      if (items.length < _pageSize) {
        _isEnd = true;
      }
      _isNotFound = items.isEmpty;
      _isSearching = false;
    });
  }

  Future<void> loadMoreItems() async {
    if (_isEnd) return;
    setState(() {
      _isLoadingMore = true;
    });
    var items = await ItemServices.getItems(-1, _searchTextEditingController.text, _pageNumber, _pageSize);
    setState(() {
      if (items.length < _pageSize) {
        _isEnd = true;
      }
      _items.addAll(items);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 56, bottom: 8, right: 20, top: 0),
          title: Container(
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10)),
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
      ),
      body: _isSearching
          ? Center(
              child: MiniIndicator(),
            )
          : _isNotFound
              ? Center(
                  child: Text(
                    S.of(context).itemNotFound(_searchTextEditingController.text),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                )
              : NotificationListener(
                  onNotification: (Notification notification) {
                    if (notification is ScrollEndNotification) {
                      _pageNumber++;
                      loadMoreItems();
                    }
                    return true;
                  },
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    children: [
                      ..._items.map((item) => InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "/item/detail", arguments: item.id);
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      item.imageUrl == null ? "https://i.stack.imgur.com/y9DpT.jpg" : item.imageUrl,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          item.itemName,
                                          style: Theme.of(context).textTheme.headline3,
                                        ),
                                        Text(
                                          "${S.of(context).receiveAddress}:",
                                          style: Theme.of(context).textTheme.bodyText1,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "${item.receiveAddress.toString()}",
                                          style: Theme.of(context).textTheme.bodyText1,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        Text(
                                          item.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Container(
                        height: screenSize.height * 0.2,
                        child: Center(
                          child: _isLoadingMore
                              ? MiniIndicator()
                              : _isEnd
                                  ? Text(
                                      S.of(context).end,
                                      style: Theme.of(context).textTheme.headline4,
                                    )
                                  : null,
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
