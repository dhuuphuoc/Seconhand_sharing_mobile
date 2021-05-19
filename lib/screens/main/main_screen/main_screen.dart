import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/screens/main/home_tab/home_tab.dart';
import 'package:secondhand_sharing/screens/main/menu_tab/menu_tab.dart';
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
                actions: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      Navigator.pushNamed(context, "/profile");
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      child: CircleAvatar(
                        radius: 20,
                        foregroundImage: AssetImage(
                          "assets/images/person.png",
                        ),
                        backgroundColor: Colors.transparent,
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
            Container(),
            Container(),
            Container(),
            Container(),
            MenuTab(),
          ],
        ),
        // Next, create a SliverList
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/post-item");
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.post_add), Text(S.of(context).post)],
          ),
        ),
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
