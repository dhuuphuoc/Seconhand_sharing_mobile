import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/invitation/invitation.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/my_group/my_group.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/post_group_card/post_group_card.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/utils/scroll_absorber/scroll_absorber.dart';
import 'package:secondhand_sharing/widgets/group_card/group_card.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';
import 'package:secondhand_sharing/widgets/notification_card/notification_card.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({Key key}) : super(key: key);

  @override
  _GroupTabState createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> with AutomaticKeepAliveClientMixin<GroupTab> {
  List<Group> _groups = [];
  List<Group> _myGroups = [];
  List<Invitation> _invitations = [];
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  int _pageSize = 8;
  bool _isLoading = true;
  bool _isEnd = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!_isEnd) {
      setState(() {
        _isLoading = true;
      });
      var groups = await GroupServices.getGroups();
      var myGroups = await GroupServices.getJoinedGroups();
      var invitations = await GroupServices.getInvitations();
      setState(() {
        _groups.addAll(groups);
        _myGroups.addAll(myGroups);
        _invitations = invitations;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> listViewWidget = [];
    if (_isLoading) {
      listViewWidget.add(SizedBox(height: screenSize.height * 0.4));
      listViewWidget.add(Center(child: MiniIndicator()));
    } else {
      if (_invitations.isNotEmpty)
        listViewWidget.add(Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, "/group/invitations", arguments: _invitations).then((value) {
                if (value != null) {
                  var acceptedInvitation = value as List<Invitation>;
                  _myGroups.addAll(acceptedInvitation
                      .map((invitation) =>
                          Group(id: invitation.groupId, groupName: invitation.groupName, avatarURL: invitation.avatarUrl))
                      .toList());
                }
              });
            },
            leading: Icon(
              Icons.mail,
              color: Theme.of(context).primaryColor,
            ),
            horizontalTitleGap: 0,
            title: Text(S.of(context).groupInvitation),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                _invitations.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ));
      listViewWidget.add(Container(
        margin: EdgeInsets.all(10),
        child: PostGroupCard(() {
          Navigator.pushNamed(context, "/create-group").then((value) {});
        }, _groups),
      ));
      listViewWidget.add(Container(
        margin: EdgeInsets.all(10),
        child: MyGroup(_myGroups),
      ));

      if (!_isEnd) {
        listViewWidget.add(NotificationCard(Icons.check_circle_outline, S.of(context).noMoreEvent));
      }
    }

    return NotificationListener(
      onNotification: (notification) {
        ScrollAbsorber.absorbScrollNotification(notification, ScreenType.main);
        return true;
      },
      child: RefreshIndicator(
        edgeOffset: screenSize.height * 0.2,
        onRefresh: () async {
          _groups = [];
          _myGroups = [];
          _pageNumber = 1;
          await fetchData();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              // This is the flip side of the SliverOverlapAbsorber
              // above.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 10),
              sliver: SliverList(delegate: SliverChildListDelegate(listViewWidget)),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
