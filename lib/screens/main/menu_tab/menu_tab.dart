import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/firebase_services/firebase_services.dart';
import 'package:secondhand_sharing/widgets/dialog/confirm_dialog/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuTab extends StatefulWidget {
  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  double _scrollOffset = 0;
  ScrollController _primaryScrollController;
  bool _isPresent = true;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      TabBar tabBar = Keys.tabBarKey.currentWidget;
      tabBar.controller.addListener(() {
        TabController tabController = tabBar.controller;
        if (tabController.indexIsChanging) {
          if (tabController.index != 5) {
            _scrollOffset = _primaryScrollController.offset;
            setState(() {
              _isPresent = false;
            });
          } else {
            setState(() {
              _isPresent = true;
            });
          }
        }
      });
    });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) super.setState(fn);
  }

  void logOut() {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            S.of(context).logout,
            S.of(context).logoutConfirmation,
          );
        }).then((value) async {
      if (value == true) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("token");
        await FirebaseServices.removeTokenFromDatabase();
        Navigator.of(context).pop();
        Navigator.pushNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isPresent) {
      _primaryScrollController = PrimaryScrollController.of(context);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_scrollOffset != 0) {
          _primaryScrollController.position.jumpTo(_scrollOffset);
          _scrollOffset = 0;
        }
      });
    }
    return _isPresent
        ? CustomScrollView(
            controller: _primaryScrollController,
            slivers: [
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber
                // above.
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 10),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    margin: EdgeInsets.all(10),
                    child: OutlinedButton(
                        onPressed: logOut,
                        child: Text("Logout"),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Theme.of(context).errorColor),
                            side: MaterialStateProperty.all(
                              BorderSide(color: Theme.of(context).errorColor, width: 1.5),
                            ),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )))),
                  ),
                ])),
              )
            ],
          )
        : Container();
  }
}
