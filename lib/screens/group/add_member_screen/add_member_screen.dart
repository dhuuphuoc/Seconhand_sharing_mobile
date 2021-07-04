import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/enums/add_member_response_type/add_member_response_type.dart';
import 'package:secondhand_sharing/models/member/member.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key key}) : super(key: key);

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  var _searchTextEditingController = TextEditingController();
  int _groupId;
  int _pageSize = 8;
  int _pageNumber = 1;
  List<Member> _users = [];
  List<Member> _addedUser = [];
  bool _isSearching = false;
  Timer _timer;

  Future<void> invite(int userId) async {
    var result = await GroupServices.inviteMember(_groupId, userId);
    if (result.type == AddMemberResponseType.invited) {
      showDialog(
          context: context,
          builder: (context) => NotifyDialog(S.of(context).success, S.of(context).invitationWasSent, "OK")).whenComplete(() {});
      return;
    }
    if (result.type == AddMemberResponseType.added) {
      showDialog(context: context, builder: (context) => NotifyDialog(S.of(context).success, S.of(context).memberAdded, "OK"))
          .whenComplete(() {
        _addedUser.add(result.member);
      });
      return;
    }
    if (result.type == AddMemberResponseType.existed) {
      showDialog(
          context: context,
          builder: (context) => NotifyDialog(S.of(context).failed, S.of(context).memberExisted, S.of(context).tryAgain));
      return;
    }
    if (result.type == AddMemberResponseType.alreadyInvited) {
      showDialog(
          context: context,
          builder: (context) => NotifyDialog(S.of(context).failed, S.of(context).userAlreadyInvited, S.of(context).tryAgain));
      return;
    }
    if (result.type == AddMemberResponseType.notExist) {
      showDialog(
          context: context,
          builder: (context) => NotifyDialog(S.of(context).failed, S.of(context).userNotExist, S.of(context).tryAgain));
      return;
    }
    showDialog(
        context: context,
        builder: (context) => NotifyDialog(S.of(context).failed, S.of(context).youAreNotAdmin, S.of(context).tryAgain));
  }

  Future<void> query(String value) async {
    _timer?.cancel();
    setState(() {
      _isSearching = true;
    });
    _pageNumber = 1;
    _users = [];
    var users = await UserServices.search(_searchTextEditingController.text, _pageNumber, _pageSize);
    setState(() {
      _users.addAll(users);
    });
    setState(() {
      _isSearching = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _groupId = ModalRoute.of(context).settings.arguments;
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _addedUser);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(
            S.of(context).addMember,
            style: Theme.of(context).textTheme.headline2,
          ),
          centerTitle: true,
          titleSpacing: 0,
        ),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                color: Colors.white,
                child: CupertinoSearchTextField(
                  controller: _searchTextEditingController,
                  onChanged: (value) {
                    _timer?.cancel();
                    _timer = Timer(Duration(milliseconds: 700), () {
                      query(value);
                    });
                  },
                  onSubmitted: query,
                  prefixInsets: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                )),
            if (_isSearching)
              Container(
                height: screenSize.height * 0.2,
                child: Center(
                  child: MiniIndicator(),
                ),
              ),
            SizedBox(height: 5),
            ..._users.map((user) => Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "/profile", arguments: user.id);
                    },
                    leading: Avatar(user.avatarUrl, 20),
                    title: Text(
                      user.fullName,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        invite(user.id);
                      },
                      child: Text(S.of(context).invite),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
