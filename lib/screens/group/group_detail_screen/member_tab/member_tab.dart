import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/add_member_model/add_member_model.dart';
import 'package:secondhand_sharing/models/enums/join_status/join_status.dart';
import 'package:secondhand_sharing/models/enums/member_role/member_role.dart';
import 'package:secondhand_sharing/models/join_request/join_request.dart';
import 'package:secondhand_sharing/models/member/member.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/utils/scroll_absorber/scroll_absorber.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/dialog/confirm_dialog/confirm_dialog.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

enum MemberActions {
  addAsAdmin,
  downToMember,
  kick,
}

class MemberTab extends StatefulWidget {
  final int groupId;
  final MemberRole role;
  final Function(MemberRole) changeRole;

  MemberTab(this.groupId, this.role, this.changeRole);

  @override
  _MemberTabState createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> with AutomaticKeepAliveClientMixin<MemberTab> {
  List<Member> _admins = [];
  List<Member> _members = [];
  List<JoinRequest> _joinRequests = [];
  var _scrollController = ScrollController();
  bool _isLoading = true;
  JoinStatus _joinStatus = JoinStatus.none;
  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) super.setState(fn);
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
    });

    if (widget.role == MemberRole.admin) {
      var joinRequests = await GroupServices.getJoinRequests(widget.groupId);
      setState(() {
        _joinRequests.addAll(joinRequests);
      });
    }
    print(widget.role);
    if (widget.role == null) {
      var joinStatus = await GroupServices.getJoinStatus(widget.groupId);
      setState(() {
        _joinStatus = joinStatus;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void addMember() {
    Navigator.pushNamed(context, "/group/add-member", arguments: widget.groupId).then((value) {
      if (value != null) {
        var member = value as Member;
        setState(() {
          _members.add(member);
        });
      }
    });
  }

  void joinGroup() {
    GroupServices.joinGroup(widget.groupId).then((value) {
      if (value)
        setState(() {
          _joinStatus = JoinStatus.requested;
        });
    });
  }

  void leaveGroup() {
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(S.of(context).leaveGroup, S.of(context).leaveGroupConfirmation)).then((value) {
      if (value == true) {
        GroupServices.leaveGroup(widget.groupId).then((result) {
          if (result) {
            setState(() {
              if (widget.role == MemberRole.admin) {
                _members.removeWhere((member) => member.id == AccessInfo().userInfo.id);
              } else {
                _admins.removeWhere((admin) => admin.id == AccessInfo().userInfo.id);
              }
            });
            widget.changeRole(null);
          } else {
            showDialog(
                context: context, builder: (context) => NotifyDialog(S.of(context).failed, S.of(context).leaveGroupError, "OK"));
          }
        });
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
            child: RefreshIndicator(
              edgeOffset: screenSize.height * 0.2,
              onRefresh: () async {
                _members = [];
                _admins = [];

                await loadMembers();
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
                    if (widget.role == MemberRole.admin)
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    S.of(context).requestToJoin,
                                    style: Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                              ),
                              if (_joinRequests.isNotEmpty)
                                ..._joinRequests.map((request) => ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                      leading: Avatar(request.avatarUrl, 18),
                                      title: Text(
                                        request.requesterName,
                                        style: Theme.of(context).textTheme.headline3,
                                      ),
                                      trailing: Container(
                                        width: 96,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: IconButton(
                                                  onPressed: () {
                                                    GroupServices.rejectJoinRequest(widget.groupId, request.requesterId)
                                                        .then((value) {
                                                      if (value) {
                                                        setState(() {
                                                          _joinRequests.remove(request);
                                                        });
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  )),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                  onPressed: () {
                                                    GroupServices.acceptJoinRequest(widget.groupId, request.requesterId)
                                                        .then((value) {
                                                      if (value) {
                                                        setState(() {
                                                          _joinRequests.remove(request);
                                                          _members.add(Member(
                                                              id: request.requesterId,
                                                              fullName: request.requesterName,
                                                              joinDate: DateTime.now(),
                                                              avatarUrl: request.avatarUrl));
                                                        });
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                              else
                                Container(
                                  height: screenSize.height * 0.1,
                                  child: Center(child: Text(S.of(context).emptyJoinRequests)),
                                )
                            ],
                          ),
                        ),
                      ),
                    if (widget.role == null)
                      if (_joinStatus != JoinStatus.invited)
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: ElevatedButton(
                              onPressed: _joinStatus == JoinStatus.requested ? null : joinGroup,
                              child:
                                  Text(_joinStatus == JoinStatus.requested ? S.of(context).requested : S.of(context).joinGroup),
                            ),
                          ),
                        )
                      else
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                            child: Column(
                              children: [
                                Text("Bạn nhận được lời mời từ nhóm"),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          GroupServices.acceptInvitation(widget.groupId).then((value) {
                                            if (value) {
                                              setState(() {
                                                widget.changeRole(MemberRole.member);
                                                var userInfo = AccessInfo().userInfo;
                                                _members.add(Member(
                                                    id: userInfo.id,
                                                    fullName: userInfo.fullName,
                                                    joinDate: DateTime.now(),
                                                    avatarUrl: userInfo.avatarUrl));
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => NotifyDialog(S.of(context).success,
                                                      S.of(context).youAreMemberOfGroup(S.of(context).thisLowerCase), "OK"));
                                            }
                                          });
                                        },
                                        child: Text(S.of(context).accept),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          GroupServices.declineInvitation(widget.groupId).then((value) {
                                            if (value) {
                                              setState(() {
                                                _joinStatus = JoinStatus.none;
                                              });
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(Theme.of(context).scaffoldBackgroundColor)),
                                        child: Text(
                                          S.of(context).decline,
                                          style: Theme.of(context).textTheme.headline4,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                      onTap: () {
                                        Navigator.pushNamed(context, "/profile", arguments: admin.id);
                                      },
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
                                                      if (admin.id == AccessInfo().userInfo.id) {
                                                        leaveGroup();
                                                      }
                                                    }
                                                  });
                                                }
                                                if (result == MemberActions.downToMember) {
                                                  GroupServices.demoteAdmin(widget.groupId, admin.id).then((value) {
                                                    if (value) {
                                                      setState(() {
                                                        _admins.remove(admin);
                                                        _members.add(admin);
                                                      });
                                                      if (admin.id == AccessInfo().userInfo.id) {
                                                        widget.changeRole(MemberRole.member);
                                                      }
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
                                      onTap: () {
                                        Navigator.pushNamed(context, "/profile", arguments: member.id);
                                      },
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
                                                if (result == MemberActions.addAsAdmin) {
                                                  GroupServices.appointAdmin(widget.groupId, member.id).then((value) {
                                                    if (value) {
                                                      setState(() {
                                                        _members.remove(member);
                                                        _admins.add(member);
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
                    widget.role != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: ElevatedButton(onPressed: leaveGroup, child: Text(S.of(context).leaveGroup)))
                        : SizedBox(height: 10),
                  ])),
                ],
              ),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
