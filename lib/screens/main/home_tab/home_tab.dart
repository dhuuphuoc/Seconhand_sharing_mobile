import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/screens/main/home_tab/local_widgets/item_card.dart';
import 'package:secondhand_sharing/screens/main/home_tab/local_widgets/post_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
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
  ScrollController _postsScrollController;
  @override
  void initState() {
    fetchItems();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _postsScrollController.addListener(() {
        if (_postsScrollController.position.maxScrollExtent ==
            _postsScrollController.offset) {
          if (!_isEnd) {
            _pageNumber++;
            fetchItems();
            _postsScrollController.animateTo(
              _postsScrollController.position.maxScrollExtent - 2,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 800),
            );
          }
        }
      });
    });
    super.initState();
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

  void fetchItems() {
    if (!_isEnd) {
      setState(() {
        _isLoading = true;
      });
      ItemServices.getItems(_pageNumber).then((value) {
        setState(() {
          _items.addAll(value);
          _isLoading = false;
          if (value.isEmpty) {
            _isEnd = true;
            _postsScrollController.animateTo(
              _postsScrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 800),
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _postsScrollController = PrimaryScrollController.of(context);

    var listViewWidgets = <Widget>[
      Container(margin: EdgeInsets.all(10), child: PostCard()),
      Container(
          margin: EdgeInsets.all(10),
          child: HorizontalCategoriesList(_categoryModel)),
    ];

    _items.forEach((item) {
      listViewWidgets.add(ItemCard(item));
    });
    if (_isLoading) {
      listViewWidgets.add(Center(
        heightFactor: 8,
        child: CircularProgressIndicator(),
      ));
    }
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
            Text("Bạn đã coi tất cả các bài viết"),
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
