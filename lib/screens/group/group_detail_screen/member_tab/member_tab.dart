import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/enums/member_role/member_role.dart';
import 'package:secondhand_sharing/models/member/member.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/utils/scroll_absorber/scroll_absorber.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

enum MemberActions {
  addAsAdmin,
  downToMember,
  kick,
}

class MemberTab extends StatefulWidget {
  final int groupId;
  final MemberRole role;

  MemberTab(this.groupId, this.role);

  @override
  _MemberTabState createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> with AutomaticKeepAliveClientMixin<MemberTab> {
  List<Member> _admins = [];
  List<Member> _members = [];
  var _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  Future<void> loadMembers() async {
    setState(() {
      _isLoading = true;
    });

    var members = await GroupServices.getMembers(widget.groupId);
    var admins = await GroupServices.getAdmins(widget.groupId);

    setState(() {
      _members.addAll(members);
      _admins.addAll(admins);
      _isLoading = false;
    });
  }

  void addMember() {
    Navigator.pushNamed(context, "/group/add-member", arguments: widget.groupId).then((value) {
      if (value == true) {
        _members = [];
        _admins = [];

        loadMembers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screenSize = MediaQuery.of(context).size;
    return _isLoading
        ? Center(
            child: MiniIndicator(),
          )
        : NotificationListener(
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
                  SizedBox(height: 10),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).requestToJoin,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    S.of(context).member,
                                    style: Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                              ),
                              if (widget.role == MemberRole.admin)
                                IconButton(
                                  onPressed: addMember,
                                  icon: Icon(
                                    Icons.add,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.zero,
                                  splashRadius: 20,
                                )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          ..._admins
                              .map((admin) => ListTile(
                                    leading: Avatar(admin.avatarUrl, 18),
                                    title: Text("${admin.fullName}", style: Theme.of(context).textTheme.headline3),
                                    subtitle: Text(S.of(context).admin),
                                    trailing: widget.role == MemberRole.admin
                                        ? PopupMenuButton<MemberActions>(
                                            onSelected: (MemberActions result) {
                                              if (result == MemberActions.kick) {
                                                GroupServices.kickMember(widget.groupId, admin.id).then((value) {
                                                  if (value) {
                                                    setState(() {
                                                      _members.remove(admin);
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<MemberActions>>[
                                              PopupMenuItem<MemberActions>(
                                                value: MemberActions.downToMember,
                                                child: Text(S.of(context).downToMember),
                                              ),
                                              PopupMenuItem<MemberActions>(
                                                value: MemberActions.kick,
                                                child: Text(S.of(context).kick),
                                              ),
                                            ],
                                          )
                                        : null,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  ))
                              .toList(),
                          ..._members
                              .map((member) => ListTile(
                                    leading: Avatar(member.avatarUrl, 18),
                                    title: Text("${member.fullName}", style: Theme.of(context).textTheme.headline3),
                                    subtitle: Text(S.of(context).member),
                                    trailing: widget.role == MemberRole.admin
                                        ? PopupMenuButton<MemberActions>(
                                            onSelected: (MemberActions result) {
                                              if (result == MemberActions.kick) {
                                                GroupServices.kickMember(widget.groupId, member.id).then((value) {
                                                  if (value) {
                                                    setState(() {
                                                      _members.remove(member);
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<MemberActions>>[
                                              PopupMenuItem<MemberActions>(
                                                value: MemberActions.addAsAdmin,
                                                child: Text(S.of(context).addAsAdmin),
                                              ),
                                              PopupMenuItem<MemberActions>(
                                                value: MemberActions.kick,
                                                child: Text(S.of(context).kick),
                                              ),
                                            ],
                                          )
                                        : null,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ])),
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
