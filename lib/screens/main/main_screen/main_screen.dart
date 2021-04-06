import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/screens/main/home_tab/home_tab.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';

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
          title: Text("Donate"),
          leading: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              "assets/images/login_icon.png",
              fit: BoxFit.cover,
            ),
          ),
          leadingWidth: 135,
          toolbarHeight: 115,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.group),
              ),
              Tab(
                icon: Icon(
                  AppIcons.hands_helping,
                  size: 18,
                ),
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
        body: TabBarView(
          children: [
            HomeTab(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
