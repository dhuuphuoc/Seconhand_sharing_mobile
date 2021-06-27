import 'package:flutter/material.dart';
import 'package:secondhand_sharing/utils/scroll_absorber/scroll_absorber.dart';

class DescriptionTab extends StatefulWidget {
  final String description;

  DescriptionTab(this.description);

  @override
  _DescriptionTabState createState() => _DescriptionTabState();
}

class _DescriptionTabState extends State<DescriptionTab> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return NotificationListener(
      onNotification: (notification) {
        ScrollAbsorber.absorbScrollNotification(notification, ScreenType.group);

        return true;
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        cacheExtent: double.infinity,
        slivers: [
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Card(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Text(widget.description),
              ),
            ),
          ])),
        ],
      ),
    );
  }
}
