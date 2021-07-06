import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/enums/member_role/member_role.dart';
import 'package:secondhand_sharing/models/group_event/group_event.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/models/post/post.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/group/group_detail_screen/post_tab/local_widget/post_card/post_card.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/services/api_services/post_services/post_services.dart';
import 'package:secondhand_sharing/utils/scroll_absorber/scroll_absorber.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/event_card/event_card.dart';
import 'package:secondhand_sharing/widgets/images_view/images_view.dart';
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
  List<Post> _posts = [];
  int _pageNumber = 1;
  int _pageSize = 10;
  bool _isLoading = false;
  bool _isEnd = false;

  Future<void> loadData() async {
    if (_isEnd) return;
    setState(() {
      _isLoading = true;
    });
    if (widget.role != null) {
      var posts = await PostServices.getPosts(widget.group.id, _pageNumber, _pageSize);
      setState(() {
        if (posts.length < _pageSize) {
          _isEnd = true;
        }
        _posts.addAll(posts);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) super.setState(fn);
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

    List<Widget> postWidgets = [];

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
          _posts = [];
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
              if (widget.role != null) ...{
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Avatar(AccessInfo().userInfo.avatarUrl, 25),
                          contentPadding: EdgeInsets.zero,
                          title: Container(
                            height: 45,
                            child: TextField(
                              readOnly: true,
                              onTap: () {
                                Navigator.pushNamed(context, "/post", arguments: widget.group).then((value) {
                                  if (value == true) {
                                    _posts = [];
                                    _pageNumber = 1;
                                    _isEnd = false;
                                    loadData();
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                hintText: "${S.of(context).postItem}...",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ..._posts.map((post) => PostCard(post)),
                SizedBox(height: 10),
                if (_isLoading)
                  Container(
                    height: screenSize.height * 0.2,
                    child: Center(
                      child: MiniIndicator(),
                    ),
                  ),
                if (_isEnd) NotificationCard(Icons.check_circle_outline, S.of(context).noMorePost),
                SizedBox(height: 20),
              } else
                Container(
                  height: screenSize.height * 0.2,
                  child: Center(
                    child: Text(
                      S.of(context).notMemberNotification,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                )
            ])),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
