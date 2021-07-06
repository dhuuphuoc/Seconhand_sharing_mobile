import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/models/item/item.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/widgets/category_tab/category_tab.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class ItemSearchTab extends StatefulWidget {
  final String keyword;
  final int categoryId;

  ItemSearchTab(this.keyword, this.categoryId);

  @override
  _ItemSearchTabState createState() => _ItemSearchTabState();
}

class _ItemSearchTabState extends State<ItemSearchTab> with AutomaticKeepAliveClientMixin<ItemSearchTab> {
  CategoryModel _categoryModel = CategoryModel.withAll();
  int _runningTasks = 0;
  int _pageSize = 8;
  int _pageNumber = 1;
  bool _isLoading = false;
  List<Item> _items = [];
  bool _isEnd = false;
  @override
  void didUpdateWidget(covariant ItemSearchTab oldWidget) {
    if (oldWidget.keyword != widget.keyword) query();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) super.setState(fn);
  }

  @override
  void initState() {
    query();
    super.initState();
  }

  Future<void> query() async {
    setState(() {
      _isLoading = true;
      _isEnd = false;
    });
    _items = [];
    _pageNumber = 1;
    _isEnd = false;
    var items = await ItemServices.getItems(_categoryModel.selectedId, widget.keyword, _pageNumber, _pageSize);
    setState(() {
      if (items.isNotEmpty) {
        _items.addAll(items);
      }
      if (items.length < _pageSize) {
        _isEnd = true;
      }
      _isLoading = false;
    });
  }

  Future<void> loadMoreItems() async {
    if (_isEnd || _isLoading) return;
    setState(() {
      _isLoading = true;
    });
    var items = await ItemServices.getItems(-1, widget.keyword, _pageNumber, _pageSize);
    setState(() {
      if (items.length < _pageSize) {
        _isEnd = true;
      }
      _items.addAll(items);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: NotificationListener(
        onNotification: (Notification notification) {
          if (notification is ScrollEndNotification) {
            _pageNumber++;
            loadMoreItems();
          }
          return true;
        },
        child: ListView(
          cacheExtent: 2000,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(10)),
              height: 130,
              child: ListView.builder(
                itemExtent: 90,
                scrollDirection: Axis.horizontal,
                itemCount: _categoryModel.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Category category = _categoryModel.categories[index];
                  return CategoryTab(category.id == _categoryModel.selectedId, category, () async {
                    setState(() {
                      _runningTasks++;
                      _categoryModel.selectedId = category.id;
                      _isEnd = false;
                      _isLoading = true;
                      _items = [];
                    });
                    _pageNumber = 1;
                    var items = await ItemServices.getItems(_categoryModel.selectedId, widget.keyword, _pageNumber, _pageSize);
                    setState(() {
                      _items = items;
                      if (items.length < _pageSize) {
                        _isEnd = true;
                      }
                      _runningTasks--;
                      if (_runningTasks == 0) {
                        _isLoading = false;
                      }
                    });
                  });
                },
              ),
            ),
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
                child: _isLoading
                    ? MiniIndicator()
                    : _isEnd
                        ? Text(
                            _items.isEmpty ? S.of(context).itemNotFound(widget.keyword) : S.of(context).end,
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

  @override
  bool get wantKeepAlive => true;
}
