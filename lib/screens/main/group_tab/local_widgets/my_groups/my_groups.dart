import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_widget/group_widget.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class MyGroups extends StatefulWidget {
  final List<Group> groups;

  MyGroups(this.groups);

  @override
  _MyGroupsState createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  bool _isLoading = false;
  bool _isEnd = false;
  int _pageNumber = 1;
  int _pageSize = 10;

  @override
  void initState() {
    if (widget.groups.length < _pageSize) {
      _isEnd = true;
    }
    super.initState();
  }

  Future<void> loadMore() async {
    if (_isEnd) return;
    setState(() {
      _isLoading = true;
    });
    _pageNumber++;
    var groups = await GroupServices.getJoinedGroups(_pageNumber, _pageSize);
    setState(() {
      if (groups.length < _pageSize) {
        _isEnd = true;
      }
      widget.groups.addAll(groups);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                S.of(context).joinedGroup.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: widget.groups.isEmpty
                ? Center(child: Text(S.of(context).emptyJoinedGroup))
                : NotificationListener(
                    onNotification: (Notification notification) {
                      if (notification is ScrollEndNotification) {
                        if (notification.metrics.axisDirection == AxisDirection.right) loadMore();
                      }
                      return true;
                    },
                    child: ListView(
                      itemExtent: 120,
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...widget.groups.map((e) => GroupWidget(e)),
                        Container(
                          child: Center(
                            child: _isLoading
                                ? MiniIndicator()
                                : _isEnd
                                    ? Text(
                                        S.of(context).end,
                                        style: Theme.of(context).textTheme.headline4,
                                      )
                                    : null,
                          ),
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
