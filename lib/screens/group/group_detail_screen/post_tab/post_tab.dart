import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/enums/member_role/member_role.dart';
import 'package:secondhand_sharing/models/group_event/group_event.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/utils/scroll_absorber/scroll_absorber.dart';
import 'package:secondhand_sharing/widgets/event_card/event_card.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';
import 'package:secondhand_sharing/widgets/notification_card/notification_card.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class PostTab extends StatefulWidget {
  final GroupDetail group;
  final MemberRole role;

  PostTab(this.group, this.role);

  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> with AutomaticKeepAliveClientMixin<PostTab> {
  ScrollController _scrollController = ScrollController();
  List<GroupEvent> _events = [];
  int _pageNumber = 1;
  int _pageSize = 8;
  bool _isLoading = false;
  bool _isEnd = false;

  Future<void> loadData() async {
    if (_isEnd) return;
    setState(() {
      _isLoading = true;
    });
    var events = await GroupServices.getGroupEvents(widget.group.id, _pageNumber, _pageSize);
    setState(() {
      if (events.length < _pageSize) {
        _isEnd = true;
      }
      _events.addAll(events);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    super.build(context);
    return NotificationListener(
      onNotification: (notification) {
        ScrollAbsorber.absorbScrollNotification(notification, ScreenType.group);
        if (notification is ScrollEndNotification) {
          _pageNumber++;
          loadData();
        }
        return true;
      },
      child: RefreshIndicator(
        edgeOffset: screenSize.height * 0.2,
        onRefresh: () async {
          _events = [];
          _pageNumber = 1;
          _isEnd = false;
          await loadData();
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
              SizedBox(height: 20),
              if (widget.role == MemberRole.admin)
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/create-event", arguments: widget.group.id).then((value) {
                          if (value != null) {
                            var event = value as GroupEvent;
                            setState(() {
                              _events.insert(0, event);
                            });
                          }
                        });
                      },
                      child: Text(S.of(context).createEvent),
                    ),
                  ),
                ),
              SizedBox(height: 10),
              ..._events.map((event) {
                event.groupName = widget.group.groupName;
                event.groupAvatar = widget.group.avatarUrl;
                return EventCard(event);
              }),
              SizedBox(height: 10),
              if (_isLoading)
                Container(
                  height: screenSize.height * 0.2,
                  child: Center(
                    child: MiniIndicator(),
                  ),
                ),
              if (_isEnd) NotificationCard(Icons.check_circle_outline, S.of(context).noMoreEvent),
              SizedBox(height: 20),
            ])),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
