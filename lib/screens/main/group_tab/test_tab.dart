import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/screens/main/home_tab/local_widgets/post_card/post_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/widgets/category_tab/category_tab.dart';
import 'package:secondhand_sharing/widgets/item_card/item_card.dart';
import 'package:secondhand_sharing/widgets/notification_card/notification_card.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({Key key}) : super(key: key);

  @override
  _GroupTabState createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> with AutomaticKeepAliveClientMixin<GroupTab> {
  CategoryModel _categoryModel = CategoryModel.withAll();
  List<Item> _items = [];
  int _pageNumber = 1;
  int _pageSize = 8;
  bool _isLoading = true;
  bool _isEnd = false;
  int _runningTasks = 0;
  ScrollController _scrollController = ScrollController();
  double _lastOffset = 0;
  @override
  void initState() {
    fetchItems();
    super.initState();

    NestedScrollView nestedScrollView = Keys.nestedScrollViewKey.currentWidget;
    ScrollController primaryScrollController = nestedScrollView.controller;
    _scrollController.addListener(() {
      double scrolled = _scrollController.offset - _lastOffset;
      _lastOffset = _scrollController.offset;
      primaryScrollController.jumpTo(primaryScrollController.offset + scrolled);
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        if (!_isEnd && !_isLoading) {
          _pageNumber++;
          fetchItems();
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  Future<void> fetchItems() async {
    if (!_isEnd) {
      setState(() {
        _isLoading = true;
      });
      var items = await ItemServices.getItems(_categoryModel.selectedId, _pageNumber, _pageSize);
      if (items.isEmpty) {
        setState(() {
          _isEnd = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _items.addAll(items);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;

    var listViewWidgets = <Widget>[
      Container(
          margin: EdgeInsets.all(10),
          child: PostCard(
            () {
              Navigator.pushNamed(context, "/post-item").then((value) {});
            },
          )),
      Container(
        margin: EdgeInsets.all(10),
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
              var items = await ItemServices.getItems(_categoryModel.selectedId, _pageNumber, _pageSize);
              setState(() {
                _items = items;
                if (_items.isEmpty) {
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
    ];

    if (_runningTasks == 0)
      _items.forEach((item) {
        listViewWidgets.add(ItemCard(item));
      });
    listViewWidgets.add(_isLoading
        ? Container(
            height: screenSize.height * 0.2,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            height: _isEnd ? 0 : screenSize.height * 0.2,
          ));
    if (_isEnd) {
      listViewWidgets.add(NotificationCard(Icons.check_circle_outline, S.of(context).endNotifyMessage));
    }
    return RefreshIndicator(
      edgeOffset: screenSize.height * 0.2,
      onRefresh: () async {
        _items = [];
        _pageNumber = 1;
        await fetchItems();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 10),
            sliver: SliverList(delegate: SliverChildListDelegate(listViewWidgets)),
          )
        ],
        // ListView(
        //   controller: _postsScrollController,
        //   children: listViewWidgets,
        // ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}