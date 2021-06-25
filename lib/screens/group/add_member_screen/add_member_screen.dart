import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key key}) : super(key: key);

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  var _searchTextEditingController = TextEditingController();
  int _groupId;

  Future<void> invite() async {
    var result = await GroupServices.inviteMember(
        _groupId, _searchTextEditingController.text);
    if (result == 0) {
      showDialog(
              context: context,
              builder: (context) => NotifyDialog(
                  S.of(context).success, S.of(context).invitationWasSent, "OK"))
          .whenComplete(() {
        Navigator.of(context).pop();
      });
    }
    if (result == 1) {
      showDialog(
          context: context,
          builder: (context) => NotifyDialog(S.of(context).failed,
              S.of(context).memberExisted, S.of(context).tryAgain));
    } else if (result == 2) {
      showDialog(
          context: context,
          builder: (context) => NotifyDialog(S.of(context).failed,
              S.of(context).emailNotExist, S.of(context).tryAgain));
    } else {
      showDialog(
          context: context,
          builder: (context) => NotifyDialog(S.of(context).failed,
              S.of(context).youAreNotAdmin, S.of(context).tryAgain));
    }
  }

  @override
  Widget build(BuildContext context) {
    _groupId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          S.of(context).addMember,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: invite,
            icon: Icon(Icons.check),
            splashRadius: 20,
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              color: Colors.white,
              child: CupertinoSearchTextField(
                controller: _searchTextEditingController,
                placeholder: "Email",
                prefixInsets:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              ))
        ],
      ),
    );
  }
}
