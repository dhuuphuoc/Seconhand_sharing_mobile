import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/screens/main/group_tab/group_tab.dart';
import 'package:secondhand_sharing/screens/main/home_tab/home_tab.dart';
import 'package:secondhand_sharing/screens/main/menu_tab/menu_tab.dart';
import 'package:secondhand_sharing/screens/main/notification_tab/notification_tab.dart';
import 'package:secondhand_sharing/services/notification_services/notification_services.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  TabController _tabController;

  Future<void> handleNotificationLaunchApp() async {
    var details = await NotificationService().flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details.didNotificationLaunchApp) {
      NotificationService().selectNotification(details.payload);
    }
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 6);
    handleNotificationLaunchApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        key: Keys.nestedScrollViewKey,
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // Add the app bar to the CustomScrollView.
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                // Provide a standard title.
                expandedHeight: 100,
                title: Image.asset(
                  "assets/images/login_icon.png",
                  height: 100,
                ),
                actions: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      Navigator.pushNamed(context, "/profile", arguments: AccessInfo().userInfo.id);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      child: CircleAvatar(
                        radius: 20,
                        foregroundImage: AccessInfo().userInfo.avatarUrl == null
                            ? AssetImage("assets/images/person.png")
                            : NetworkImage(AccessInfo().userInfo.avatarUrl),
                        backgroundImage: AssetImage(
                          "assets/images/person.png",
                        ),
                      ),
                    ),
                  ),
                ],
                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                floating: true,
                pinned: true,
                // Display a placeholder widget to visualize the shrinking size.
                // Make the initial height of the SliverAppBar larger than normal.
                // expandedHeight: 100,
                bottom: TabBar(
                  controller: _tabController,
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
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeTab(),
            GroupTab(),
            Container(),
            Container(),
            NotificationTab(),
            MenuTab(),
          ],
        ),
      ),
    );
  }
}
