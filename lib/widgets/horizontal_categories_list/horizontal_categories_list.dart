import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';

class HorizontalCategoriesList extends StatefulWidget {
  final CategoryModel _categoryModel;

  HorizontalCategoriesList(this._categoryModel);

  @override
  _HorizontalCategoriesListState createState() =>
      _HorizontalCategoriesListState();
}

class _HorizontalCategoriesListState extends State<HorizontalCategoriesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      height: 130,
      child: ListView.builder(
        itemExtent: 90,
        scrollDirection: Axis.horizontal,
        itemCount: widget._categoryModel.categories.length,
        itemBuilder: (BuildContext context, int index) {
          Category category = widget._categoryModel.categories[index];
          return InkWell(
            onTap: () {
              setState(() {
                widget._categoryModel.selectedId = category.id;
              });
            },
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor:
                        widget._categoryModel.selectedId == category.id
                            ? Theme.of(context).selectedRowColor
                            : Theme.of(context).scaffoldBackgroundColor,
                    child: Icon(
                      category.icon,
                      size: 20,
                      color: widget._categoryModel.selectedId == category.id
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
                        color: widget._categoryModel.selectedId == category.id
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
