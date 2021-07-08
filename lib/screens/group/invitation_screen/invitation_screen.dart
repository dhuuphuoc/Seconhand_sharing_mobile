import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/invitation/invitation.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key key}) : super(key: key);

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  List<Invitation> _invitations;
  List<Invitation> _acceptedInvitations = [];
  StreamSubscription<RemoteMessage> _subscription;
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _subscription = FirebaseMessaging.onMessage.listen((message) {
      if (message.data["type"] == "7") {
        setState(() {
          _invitations = ModalRoute.of(context).settings.arguments;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_invitations == null) {
      _invitations = ModalRoute.of(context).settings.arguments;
    }
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_acceptedInvitations);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).groupInvitation,
            style: Theme.of(context).textTheme.headline3,
          ),
          centerTitle: true,
        ),
        body: _invitations.length == 0
            ? Center(
                child: Text(
                  S.of(context).noAnyInvitations,
                  style: Theme.of(context).textTheme.headline4,
                ),
              )
            : ListView(
                children: _invitations
                    .map(
                      (invitation) => InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/group/detail", arguments: invitation.groupId);
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Avatar(invitation.avatarUrl, 40),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        invitation.groupName,
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        TimeAgo.parse(invitation.invitationTime,
                                            locale: Localizations.localeOf(context).languageCode),
                                        style: Theme.of(context).textTheme.subtitle2,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                GroupServices.declineInvitation(invitation.groupId).then((value) {
                                                  if (value) {
                                                    setState(() {
                                                      _invitations.remove(invitation);
                                                    });
                                                  }
                                                });
                                              },
                                              child: Text(
                                                S.of(context).decline,
                                                style: Theme.of(context).textTheme.headline4,
                                              ),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(Theme.of(context).scaffoldBackgroundColor)),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                GroupServices.acceptInvitation(invitation.groupId).then((value) {
                                                  if (value) {
                                                    setState(() {
                                                      _invitations.remove(invitation);
                                                      _acceptedInvitations.add(invitation);
                                                    });
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => NotifyDialog(S.of(context).success,
                                                            S.of(context).youAreMemberOfGroup(invitation.groupName), "OK"));
                                                  }
                                                });
                                              },
                                              child: Text(S.of(context).accept),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
