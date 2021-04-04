import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/models/item_model/item.dart';
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
  @override
  void initState() {
    ItemServices.getItems(_pageNumber).then((value) {
      setState(() {
        _items.addAll(value);
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listViewWidgets = <Widget>[
      Container(margin: EdgeInsets.all(10), child: PostCard()),
      Container(
          margin: EdgeInsets.all(10),
          child: HorizontalCategoriesList(_categoryModel)),
    ];
    if (_isLoading) {
      listViewWidgets.add(Center(
        heightFactor: 8,
        child: CircularProgressIndicator(),
      ));
    }
    _items.forEach((item) {
      listViewWidgets.add(Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.imageUrl,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 5),
                child: Text(
                  item.itemName,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Text(
                  "${TimeAgo.parse(item.postTime, locale: Localizations.localeOf(context).languageCode)} - ${item.receiveAddress}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Divider(
                height: 3,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Text(
                  item.description,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ));
    });
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        children: listViewWidgets,
      ),
    );
  }
}
