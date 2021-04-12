import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/screens/main/home_tab/home_tab.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 6);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _scrollController.dispose();
          _scrollController = ScrollController();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
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
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
        // Next, create a SliverList
      ),
      // appBar: AppBar(
      //   leading: Container(
      //     padding: EdgeInsets.symmetric(horizontal: 10),
      //     child: Image.asset(
      //       "assets/images/login_icon.png",
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      //   leadingWidth: 135,
      //   toolbarHeight: 115,
      //   bottom: TabBar(
      //     tabs: [
      //       Tab(
      //         icon: Icon(Icons.home),
      //       ),
      //       Tab(
      //         icon: Icon(Icons.group),
      //       ),
      //       Tab(
      //         icon: Icon(
      //           AppIcons.hands_helping,
      //           size: 18,
      //         ),
      //       ),
      //       Tab(
      //         icon: Icon(Icons.stars),
      //       ),
      //       Tab(
      //         icon: Icon(Icons.notifications),
      //       ),
      //       Tab(
      //         icon: Icon(Icons.menu),
      //       ),
      //     ],
      //   ),
      // ),
      // body: TabBarView(
      //   children: [
      //     HomeTab(),
      //     Container(),
      //     Container(),
      //     Container(),
      //     Container(),
      //     Container(),
      //   ],
      // ),
    );
  }
}
