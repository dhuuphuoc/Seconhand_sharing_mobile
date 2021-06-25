import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/member/member.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';

enum MemberActions {
  addAsAdmin,
  kick,
}

class MemberTab extends StatefulWidget {
  final int groupId;

  MemberTab(this.groupId);

  @override
  _MemberTabState createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab>
    with AutomaticKeepAliveClientMixin<MemberTab> {
  List<Member> _members = [];
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

    setState(() {
      _members.addAll(members);
      _isLoading = false;
    });
  }

  void addMember() {
    Navigator.pushNamed(context, "/group/add-member",
        arguments: widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: [
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
                          Text(
                            S.of(context).member,
                            style: Theme.of(context).textTheme.headline3,
                          ),
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
                      ..._members
                          .map((member) => Container(
                                child: ListTile(
                                  leading: Avatar(member.avatarUrl, 18),
                                  title: Text("${member.fullName}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  trailing: PopupMenuButton<MemberActions>(
                                    onSelected: (MemberActions result) {
                                      if (result == MemberActions.kick) {
                                        GroupServices.kickMember(
                                                widget.groupId, member.id)
                                            .then((value) {
                                          if (value) {
                                            setState(() {
                                              _members.remove(member);
                                            });
                                          }
                                        });
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<MemberActions>>[
                                      PopupMenuItem<MemberActions>(
                                        value: MemberActions.addAsAdmin,
                                        child: Text(S.of(context).addAsAdmin),
                                      ),
                                      PopupMenuItem<MemberActions>(
                                        value: MemberActions.kick,
                                        child: Text(S.of(context).kick),
                                      ),
                                    ],
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              )
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
