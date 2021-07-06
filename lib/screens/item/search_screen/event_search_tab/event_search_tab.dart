import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_event/group_event.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/invitation/invitation.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/create_group_card/create_group_card.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_avatar/group_avatar.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_widget/group_widget.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/my_groups/my_groups.dart';
import 'package:secondhand_sharing/services/api_services/event_services/event_services.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/utils/scroll_absorber/scroll_absorber.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/event_card/event_card.dart';
import 'package:secondhand_sharing/widgets/group_card/group_card.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';
import 'package:secondhand_sharing/widgets/notification_card/notification_card.dart';

class EventSearchTab extends StatefulWidget {
  final String keyword;

  EventSearchTab(this.keyword);

  @override
  _EventSearchTabState createState() => _EventSearchTabState();
}

class _EventSearchTabState extends State<EventSearchTab> with AutomaticKeepAliveClientMixin<EventSearchTab> {
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  int _pageSize = 8;
  List<GroupEvent> _events = [];
  bool _isLoading = true;
  bool _isEnd = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void didUpdateWidget(covariant EventSearchTab oldWidget) {
    if (oldWidget.keyword != widget.keyword) {
      _isEnd = false;
      _events = [];
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
    var events = await EventServices.getEvents(widget.keyword, _pageNumber, _pageSize);
    setState(() {
      if (events.length < _pageSize) {
        _isEnd = true;
      }
      _events.addAll(events);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> listViewWidget = [];

    _events.forEach((event) {
      listViewWidget.add(EventCard(event));
    });
    listViewWidget.add(SizedBox(height: 5));
    if (!_isEnd)
      listViewWidget.add(Container(
        height: screenSize.height * 0.2,
        child: Center(
          child: _isLoading ? MiniIndicator() : null,
        ),
      ));

    if (_isEnd) {
      listViewWidget.add(NotificationCard(Icons.check_circle_outline, S.of(context).noMoreEvent));
    }

    return _events.isEmpty && !_isLoading
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
            child: ListView(
                controller: _scrollController,
                cacheExtent: 5000,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 10),
                children: listViewWidget),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
