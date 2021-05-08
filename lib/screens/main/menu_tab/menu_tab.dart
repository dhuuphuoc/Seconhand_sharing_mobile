import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/widgets/dialog/confirm_dialog/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuTab extends StatefulWidget {
  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  void logOut() {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
              S.of(context).logout,
              S.of(context).logoutConfirmation,
              S.of(context).yes,
              S.of(context).no);
        }).then((value) async {
      if (value == true) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("token");
        Navigator.of(context).pop();
        Navigator.pushNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).errorColor),
                      side: MaterialStateProperty.all(
                        BorderSide(
                            color: Theme.of(context).errorColor, width: 1.5),
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )))),
            ),
          ])),
        )
      ],
    );
  }
}
