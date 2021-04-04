import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/widgets/icons/awesome5_icons.dart';
import 'package:secondhand_sharing/widgets/icons/custom_icons.dart';
import 'package:secondhand_sharing/widgets/icons/linecons_icons.dart';

class CategoryModel {
  List<Category> categories = [
    Category(id: 1, name: S.current.clothes, icon: CustomIcons.clothes),
    Category(id: 2, name: S.current.houseware, icon: CustomIcons.houseware),
    Category(id: 3, name: S.current.stationery, icon: CustomIcons.stationery),
    Category(id: 4, name: S.current.sport, icon: Awesome5Icons.running),
    Category(id: 5, name: S.current.electronic, icon: CustomIcons.electronic),
    Category(id: 6, name: S.current.furniture, icon: CustomIcons.furniture),
    Category(id: 7, name: S.current.other, icon: CustomIcons.other),
  ];
  int selectedId;

  CategoryModel() {
    selectedId = 1;
  }

  CategoryModel.withAll() {
    Category allCategory =
        Category(id: -1, name: S.current.all, icon: Icons.view_headline);
    categories.insert(0, allCategory);
    selectedId = -1;
  }
}
