import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  ScrollDirection _scrollDirection = ScrollDirection.idle;
  bool _isHideIcon = false;
  bool _isMe = true;
  bool _isEditing = false;
  var _nameTextController = TextEditingController();
  var _phoneTextController = TextEditingController();
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    initScrollController();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _scrollController.dispose();
          initScrollController();
        });
      }
    });
    super.initState();
  }

  void initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection != _scrollDirection) {
        setState(() {
          _scrollDirection = _scrollController.position.userScrollDirection;
          if (_scrollDirection == ScrollDirection.reverse) {
            _isHideIcon = true;
          }
        });
      }
      if (_scrollController.position.minScrollExtent ==
          _scrollController.offset) {
        setState(() {
          _isHideIcon = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var dateFormat = DateFormat("dd/MM/yyyy");
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
                expandedHeight: screenSize.height * 0.6,
                actions: [
                  if (_isMe)
                    _isEditing
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            child: Text(S.of(context).save))
                        : IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                                _nameTextController.text =
                                    AccessInfo().userInfo.fullName;
                              });
                            }),
                ],
                title: Text(
                  S.of(context).profile,
                  style: Theme.of(context).textTheme.headline2,
                ),
                onStretchTrigger: () async {
                  print("hello");
                },
                centerTitle: true,
                flexibleSpace: Container(
                  margin: EdgeInsets.symmetric(vertical: kToolbarHeight),
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CircleAvatar(
                            radius: screenSize.height * 0.1,
                            foregroundImage: AssetImage(
                              "assets/images/person.png",
                            ),
                          ),
                        ),
                        Expanded(
                          child: _isEditing
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: 100),
                                  child: IntrinsicWidth(
                                    child: _isHideIcon
                                        ? null
                                        : TextFormField(
                                            controller: _nameTextController,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                )
                              : Text(
                                  AccessInfo().userInfo.fullName,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                        ),
                        Expanded(
                          child: Container(
                            child: ListTile(
                              leading: _isHideIcon
                                  ? null
                                  : Icon(
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              title: Text(
                                  AccessInfo().userInfo.phoneNumber == null
                                      ? ""
                                      : AccessInfo().userInfo.phoneNumber),
                              trailing: _isHideIcon || _isMe
                                  ? null
                                  : IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () async {
                                        await canLaunch(
                                                "mailto:${AccessInfo().userInfo.phoneNumber}?subject=&body=")
                                            ? await launch(
                                                "mailto:${AccessInfo().userInfo.phoneNumber}?subject=&body=")
                                            : throw 'Could not launch mailto:${AccessInfo().userInfo.phoneNumber}?subject=&body=';
                                      },
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: ListTile(
                              leading: _isHideIcon
                                  ? null
                                  : Icon(
                                      Icons.contact_phone,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              title: _isEditing
                                  ? _isHideIcon
                                      ? null
                                      : TextFormField(
                                          controller: _phoneTextController,
                                        )
                                  : Text(
                                      AccessInfo().userInfo.phoneNumber == null
                                          ? ""
                                          : AccessInfo().userInfo.phoneNumber),
                              trailing: _isHideIcon || _isMe
                                  ? null
                                  : IconButton(
                                      icon: Icon(
                                        Icons.call,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () async {
                                        await canLaunch(
                                                "tel:${AccessInfo().userInfo.phoneNumber}")
                                            ? await launch(
                                                "tel:${AccessInfo().userInfo.phoneNumber}")
                                            : throw "Could not launch tel:${AccessInfo().userInfo.phoneNumber}";
                                      },
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: _isHideIcon
                                ? null
                                : Icon(
                                    AppIcons.birthday,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            title: Text(AccessInfo().userInfo.dob == null
                                ? ""
                                : dateFormat.format(AccessInfo().userInfo.dob)),
                            trailing: _isEditing
                                ? _isHideIcon
                                    ? null
                                    : IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          AppIcons.calendar_day,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                floating: false,
                pinned: true,
                // Display a placeholder widget to visualize the shrinking size.
                // Make the initial height of the SliverAppBar larger than normal.
                // expandedHeight: 100,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: S.of(context).registrations,
                    ),
                    Tab(
                      text: S.of(context).donation,
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
            Container(),
            Container(),
          ],
        ),
        // Next, create a SliverList
      ),
    );
  }
}
