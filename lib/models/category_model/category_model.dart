import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/widgets/icons/category_icons.dart';

class CategoryModel {
  List<Category> categories = [
    Category(id: 1, name: S.current.clothes, icon: CategoryIcons.clothes),
    Category(id: 2, name: S.current.houseware, icon: CategoryIcons.houseware),
    Category(id: 3, name: S.current.study, icon: CategoryIcons.book),
    Category(id: 4, name: S.current.sport, icon: CategoryIcons.running),
    Category(id: 5, name: S.current.electronic, icon: CategoryIcons.electronic),
    Category(id: 6, name: S.current.furniture, icon: CategoryIcons.furniture),
    Category(id: 7, name: S.current.other, icon: CategoryIcons.other),
  ];
  int selectedId;

  CategoryModel();

  CategoryModel.withAll() {
    Category allCategory =
        Category(id: -1, name: S.current.all, icon: Icons.view_headline);
    categories.insert(0, allCategory);
    selectedId = -1;
  }
}
