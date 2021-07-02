import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_widget/group_widget.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class CreateGroupCard extends StatefulWidget {
  final List<Group> groups;

  CreateGroupCard(this.groups);

  @override
  _CreateGroupCardState createState() => _CreateGroupCardState();
}

class _CreateGroupCardState extends State<CreateGroupCard> {
  int _pageNumber = 1;
  int _pageSize = 10;
  bool _isEnd = false;
  bool _isLoading = false;

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
    var groups = await GroupServices.getGroups(_pageNumber, _pageSize);
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
    Size screenSize = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 10,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    S.of(context).group.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/create-group").then((value) {});
                      },
                      child: Text(
                        "+ " + S.of(context).createGroup,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: widget.groups.isEmpty
                ? Center(
                    child: Text(S.of(context).emptyGroup),
                  )
                : NotificationListener(
                    onNotification: (Notification notification) {
                      if (notification is ScrollEndNotification) {
                        if (notification.metrics.axisDirection == AxisDirection.right) loadMore();
                      }
                      return true;
                    },
                    child: ListView(
                      itemExtent: screenSize.width * 0.35,
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
