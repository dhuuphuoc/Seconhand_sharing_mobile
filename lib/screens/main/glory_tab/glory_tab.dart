import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/glory/glory.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class GloryTab extends StatefulWidget {
  const GloryTab({Key key}) : super(key: key);

  @override
  _GloryTabState createState() => _GloryTabState();
}

class _GloryTabState extends State<GloryTab>
    with AutomaticKeepAliveClientMixin<GloryTab> {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<Glory> _topAwards = [];

  void absorbScrollBehaviour(double scrolled) {
    NestedScrollView nestedScrollView = Keys.nestedScrollViewKey.currentWidget;
    ScrollController primaryScrollController = nestedScrollView.controller;
    primaryScrollController.jumpTo(primaryScrollController.offset + scrolled);
  }

  @override
  void initState() {
    super.initState();
    fetchTopAwards();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  Future<void> fetchTopAwards() async {
    setState(() {
      _isLoading = true;
    });
    var topAwards = await UserServices.getTopAwards();
    setState(() {
      _topAwards.addAll(topAwards);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;

    List<Widget> widgets = [
      Container(
        padding: EdgeInsets.only(left: 18, right: 5),
        height: screenSize.height * 0.07,
        color: Theme.of(context).backgroundColor,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).glory,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      )
    ];
    if (_isLoading) {
      widgets.add(SizedBox(height: screenSize.height * 0.4));
      widgets.add(Center(child: MiniIndicator()));
    } else {
      widgets.add(SizedBox(height: 5));
      _topAwards.forEach((glory) {
        widgets.add(Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/profile",
                  arguments: glory.accountId);
            },
            child: Container(
              height: screenSize.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Avatar(glory.avatarUrl, 22),
                  SizedBox(height: 10),
                  Text(glory.donateAccountName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/glory.jpg"),
                      fit: BoxFit.fill)),
            ),
          ),
        ));
      });
      widgets.add(SizedBox(height: 100));
    }

    return NotificationListener(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          absorbScrollBehaviour(notification.overscroll);
        }
        if (notification is ScrollUpdateNotification) {
          absorbScrollBehaviour(notification.scrollDelta);
        }

        return true;
      },
      child: RefreshIndicator(
        edgeOffset: screenSize.height * 0.02,
        onRefresh: () async {
          _topAwards = [];
          await fetchTopAwards();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          cacheExtent: double.infinity,
          slivers: [
            SliverOverlapInjector(
              // This is the flip side of the SliverOverlapAbsorber
              // above.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0),
              sliver: SliverList(delegate: SliverChildListDelegate(widgets)),
            )
          ],
          // ListView(
          //   padding: EdgeInsets.only(bottom: 10),
          //   controller: _scrollController,
          //   children: listViewWidgets,
          //   // ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
