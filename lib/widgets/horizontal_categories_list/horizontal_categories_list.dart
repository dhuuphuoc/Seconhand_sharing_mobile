import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';

class HorizontalCategoriesList extends StatefulWidget {
  @override
  _HorizontalCategoriesListState createState() =>
      _HorizontalCategoriesListState();
}

class _HorizontalCategoriesListState extends State<HorizontalCategoriesList> {
  @override
  Widget build(BuildContext context) {
    CategoryModel categoryModel = Provider.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryModel.categories.length,
        itemBuilder: (BuildContext context, int index) {
          Category category = categoryModel.categories[index];
          return InkWell(
            onTap: () {
              setState(() {
                categoryModel.selectedId = category.id;
              });
            },
            child: Container(
              width: 80,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: categoryModel.selectedId == category.id
                        ? Theme.of(context).selectedRowColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: Icon(
                      category.icon,
                      size: 20,
                      color: categoryModel.selectedId == category.id
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).unselectedWidgetColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                        color: categoryModel.selectedId == category.id
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).unselectedWidgetColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
