import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/models/item/item.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/widgets/item_card/item_card.dart';
import 'package:secondhand_sharing/screens/main/home_tab/local_widgets/post_card/post_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/widgets/category_tab/category_tab.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';
import 'package:secondhand_sharing/widgets/notification_card/notification_card.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin<HomeTab> {
  CategoryModel _categoryModel = CategoryModel.withAll();
  List<Item> _items = [];
  int _pageNumber = 1;
  int _pageSize = 8;
  bool _isLoading = true;
  bool _isEnd = false;
  int _runningTasks = 0;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  void absorbScrollBehaviour(double scrolled) {
    NestedScrollView nestedScrollView = Keys.nestedScrollViewKey.currentWidget;
    ScrollController primaryScrollController = nestedScrollView.controller;
    primaryScrollController.jumpTo(primaryScrollController.offset + scrolled);
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
      var items = await ItemServices.getItems(
          _categoryModel.selectedId, _pageNumber, _pageSize);
      setState(() {
        if (items.length < _pageSize) {
          _isEnd = true;
        }
        _items.addAll(items);
        _isLoading = false;
      });
    }
  }

  Future<void> reload() async {
    _items = [];
    _pageNumber = 1;
    _isEnd = false;

    await fetchItems();
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
              Navigator.pushNamed(context, "/post-item").then((value) {
                if (value == true) {
                  reload();
                }
              });
            },
          )),
      Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(10)),
        height: 130,
        child: ListView.builder(
          itemExtent: 90,
          scrollDirection: Axis.horizontal,
          itemCount: _categoryModel.categories.length,
          itemBuilder: (BuildContext context, int index) {
            Category category = _categoryModel.categories[index];
            return CategoryTab(
                category.id == _categoryModel.selectedId, category, () async {
              setState(() {
                _runningTasks++;
                _categoryModel.selectedId = category.id;
                _isEnd = false;
                _isLoading = true;
                _items = [];
              });
              _pageNumber = 1;
              var items = await ItemServices.getItems(
                  _categoryModel.selectedId, _pageNumber, _pageSize);
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
    ];

    if (_runningTasks == 0)
      _items.forEach((item) {
        listViewWidgets.add(ItemCard(item));
      });
    listViewWidgets.add(Container(
      height: _isEnd ? 0 : screenSize.height * 0.2,
      child: Center(
        child: _isLoading ? MiniIndicator() : Container(),
      ),
    ));

    if (_isEnd) {
      listViewWidgets.add(NotificationCard(
          Icons.check_circle_outline, S.of(context).endNotifyMessage));
    }

    return NotificationListener(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          if (notification.metrics.axisDirection == AxisDirection.up ||
              notification.metrics.axisDirection == AxisDirection.down)
            absorbScrollBehaviour(notification.overscroll);
          if (notification.overscroll > 0) {
            if (!_isEnd && !_isLoading) {
              _pageNumber++;
              fetchItems();
            }
          }
        }
        if (notification is ScrollUpdateNotification) {
          if (notification.metrics.axisDirection == AxisDirection.up ||
              notification.metrics.axisDirection == AxisDirection.down)
            absorbScrollBehaviour(notification.scrollDelta);
        }
        return true;
      },
      child: RefreshIndicator(
        edgeOffset: screenSize.height * 0.2,
        onRefresh: reload,
        child: CustomScrollView(
          key: Keys.primaryScrollViewKey,
          cacheExtent: double.infinity,
          controller: _scrollController,
          slivers: [
            SliverOverlapInjector(
              // This is the flip side of the SliverOverlapAbsorber
              // above.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 10),
              sliver: SliverList(
                  delegate: SliverChildListDelegate(listViewWidgets)),
            )
          ],
          // ListView(
          //   controller: _postsScrollController,
          //   children: listViewWidgets,
          // ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
