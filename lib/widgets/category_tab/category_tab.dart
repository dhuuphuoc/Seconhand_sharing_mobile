import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';

class CategoryTab extends StatefulWidget {
  final bool _isSelected;
  final Category _category;
  final Function _onSelected;

  CategoryTab(this._isSelected, this._category, this._onSelected);

  @override
  _CategoryTabState createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget._onSelected,
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: widget._isSelected
                  ? Theme.of(context).selectedRowColor
                  : Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                widget._category.icon,
                size: 20,
                color: widget._isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).unselectedWidgetColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget._category.name,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                  color: widget._isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).unselectedWidgetColor),
            ),
          ],
        ),
      ),
    );
  }
}
