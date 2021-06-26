import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/create_group/create_group.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ruleController = TextEditingController();
  bool _isLoading = false;

  void onSubmit() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _isLoading = true;
    });

    Group group = await GroupServices.createGroup(CreateGroupForm(
        _groupNameController.text,
        _descriptionController.text,
        _ruleController.text));

    if (group != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return NotifyDialog(
              S.of(context).success, S.of(context).createGroupSuccess, "OK");
        },
      ).whenComplete(() {
        Navigator.pushNamed(context, "/group/detail", arguments: group.id);
      });
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return NotifyDialog(S.of(context).failed,
              S.of(context).createGroupFail, S.of(context).tryAgain);
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).createGroup,
            style: Theme.of(context).textTheme.headline2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                TextFormField(
                  controller: _groupNameController,
                  validator: Validator.validateGroupName,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: "${S.of(context).groupName}",
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  minLines: 8,
                  maxLines: 20,
                  validator: Validator.validateDescription,
                  controller: _descriptionController,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      hintText: "${S.of(context).description}...",
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  minLines: 4,
                  maxLines: 15,
                  controller: _ruleController,
                  validator: Validator.validateRule,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      hintText: "${S.of(context).rule}...",
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 15,
                ),
                _isLoading ? Align(child: MiniIndicator()) : SizedBox(),
                SizedBox(
                  height: 15,
                ),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _isLoading ? null : onSubmit,
                        child: Text(S.of(context).confirm))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
