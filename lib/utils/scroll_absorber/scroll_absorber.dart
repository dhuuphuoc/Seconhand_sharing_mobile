import 'package:flutter/material.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';

enum ScreenType { main, group }

class ScrollAbsorber {
  static void absorbScrollNotification(Notification notification, ScreenType type) {
    NestedScrollView nestedScrollView;
    double scrolled = 0;
    if (type == ScreenType.main) {
      nestedScrollView = Keys.mainScreenNestedScrollViewKey.currentWidget;
    } else {
      nestedScrollView = Keys.groupScreenNestedScrollViewKey.currentWidget;
    }
    if (notification is OverscrollNotification) {
      if (notification.metrics.axisDirection == AxisDirection.up || notification.metrics.axisDirection == AxisDirection.down)
        scrolled = notification.overscroll;
    }
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.axisDirection == AxisDirection.up || notification.metrics.axisDirection == AxisDirection.down)
        scrolled = notification.scrollDelta;
    }
    ScrollController primaryScrollController = nestedScrollView.controller;
    primaryScrollController.jumpTo(primaryScrollController.offset + scrolled);
  }
}
