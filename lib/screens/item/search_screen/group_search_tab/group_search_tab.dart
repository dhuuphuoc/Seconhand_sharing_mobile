import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_widget/group_widget.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/widgets/group_card/group_card.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';
import 'package:secondhand_sharing/widgets/notification_card/notification_card.dart';

class GroupSearchTab extends StatefulWidget {
  final String keyword;

  GroupSearchTab(this.keyword);

  @override
  _EventSearchTabState createState() => _EventSearchTabState();
}

class _EventSearchTabState extends State<GroupSearchTab> with AutomaticKeepAliveClientMixin<GroupSearchTab> {
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  int _pageSize = 20;
  List<Group> _groups = [];
  bool _isLoading = true;
  bool _isEnd = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void didUpdateWidget(covariant GroupSearchTab oldWidget) {
    if (oldWidget.keyword != widget.keyword) {
      _isEnd = false;
      _groups = [];
      _pageNumber = 1;
      loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> loadData() async {
    if (_isEnd) return;
    setState(() {
      _isLoading = true;
    });
    var groups = await GroupServices.getGroups(widget.keyword, _pageNumber, _pageSize);
    setState(() {
      if (groups.length < _pageSize) {
        _isEnd = true;
      }
      _groups.addAll(groups);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> listViewWidget = [];

    _groups.forEach((group) {
      listViewWidget.add(GroupWidget(group));
    });
    listViewWidget.add(Container(
      height: screenSize.height * 0.2,
      child: Center(
        child: _isLoading
            ? MiniIndicator()
            : _isEnd
                ? Text(S.of(context).end)
                : null,
      ),
    ));

    return _groups.isEmpty && !_isLoading
        ? Center(
            child: Text(
              S.of(context).eventNotFound(widget.keyword),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        : NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                _pageNumber++;
                loadData();
              }
              return true;
            },
            child: GridView.count(
                controller: _scrollController,
                cacheExtent: 5000,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: listViewWidget),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
