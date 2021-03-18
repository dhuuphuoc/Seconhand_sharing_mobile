import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/custom_icons/custom_icons.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            "assets/images/login_icon.png",
            fit: BoxFit.cover,
          ),
          leadingWidth: 125,
          toolbarHeight: 125,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.group),
              ),
              Tab(
                icon: Icon(CustomIcons.honors),
              ),
              Tab(
                icon: Icon(Icons.stars),
              ),
              Tab(
                icon: Icon(Icons.notifications),
              ),
              Tab(
                icon: Icon(Icons.menu),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
