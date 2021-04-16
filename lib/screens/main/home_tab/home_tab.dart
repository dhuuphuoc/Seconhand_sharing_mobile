import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/screens/main/home_tab/local_widgets/item_card.dart';
import 'package:secondhand_sharing/screens/main/home_tab/local_widgets/post_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/category_tab.dart';
import 'package:secondhand_sharing/widgets/horizontal_categories_list/horizontal_categories_list.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  CategoryModel _categoryModel = CategoryModel.withAll();
  List<Item> _items = [];
  int _pageNumber = 1;
  bool _isLoading = true;
  bool _isEnd = false;
  int _runningTasks = 0;
  ScrollController _postsScrollController;
  @override
  void initState() {
    fetchItems();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _postsScrollController.addListener(() {
        if (_postsScrollController.position.maxScrollExtent ==
            _postsScrollController.offset) {
          if (!_isEnd && !_isLoading) {
            _pageNumber++;
            fetchItems();
          }
        }
      });
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
    super.dispose();
  }

  Future<void> fetchItems() async {
    if (!_isEnd) {
      setState(() {
        _isLoading = true;
      });
      var items =
          await ItemServices.getItems(_pageNumber, _categoryModel.selectedId);
      if (items.isEmpty) {
        setState(() {
          _isEnd = true;
          _isLoading = false;
        });
        _postsScrollController.animateTo(
          _postsScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
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
    _postsScrollController = PrimaryScrollController.of(context);

    var listViewWidgets = <Widget>[
      Container(margin: EdgeInsets.all(10), child: PostCard()),
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
              print(_runningTasks);
              setState(() {
                _runningTasks++;
                _categoryModel.selectedId = category.id;
                _isEnd = false;
                _isLoading = true;
                _items = [];
              });
              _pageNumber = 1;
              var items = await ItemServices.getItems(
                  _pageNumber, _categoryModel.selectedId);
              setState(() {
                _items = items;
                _runningTasks--;
                print(_runningTasks);
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
        ? Center(
            heightFactor: 8,
            child: CircularProgressIndicator(),
          )
        : Container(
            height: _isEnd ? 0 : 250,
          ));
    if (_isEnd) {
      listViewWidgets.add(Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text(S.of(context).endNotifyMessage),
            SizedBox(height: 10),
          ],
        ),
      ));
    }
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          // This is the flip side of the SliverOverlapAbsorber
          // above.
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 10),
          sliver:
              SliverList(delegate: SliverChildListDelegate(listViewWidgets)),
        )
      ],
      // ListView(
      //   controller: _postsScrollController,
      //   children: listViewWidgets,
      // ),
    );
  }
}
