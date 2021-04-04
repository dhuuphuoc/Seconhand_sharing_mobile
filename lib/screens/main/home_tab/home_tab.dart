import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/screens/main/home_tab/local_widgets/post_card.dart';
import 'package:secondhand_sharing/widgets/horizontal_categories_list/horizontal_categories_list.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  CategoryModel _categoryModel = CategoryModel.withAll();
  bool _isLoading = true;
  @override
  void initState() {
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        children: [
          PostCard(),
          SizedBox(
            height: 10,
          ),
          _isLoading
              ? Center(heightFactor: 15, child: CircularProgressIndicator())
              : Provider(
                  create: (_) => _categoryModel,
                  child: HorizontalCategoriesList(),
                ),
        ],
      ),
    );
  }
}
