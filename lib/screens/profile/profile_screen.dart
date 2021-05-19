import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';
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
  DateTime _dob;
  ScrollDirection _scrollDirection = ScrollDirection.idle;
  bool _isHideIcon = false;
  bool _isMe = true;
  bool _isEditing = false;
  UserInfo _userInfo = UserInfo();
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _dob = _userInfo.dob;
      });
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

  void modifyDob() {
    showDatePicker(
            context: context,
            initialDate: _dob,
            firstDate: DateTime.utc(1),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        if (value != null) {
          _dob = value;
        }
      });
    });
  }

  void modifyAddress() {
    AddressModel backup = AddressModel.clone(_userInfo.address);
    Navigator.pushNamed(context, "/item/address", arguments: _userInfo.address)
        .then((value) {
      setState(() {
        if (value != null)
          _userInfo.address = value;
        else {
          _userInfo.address = backup;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var dateFormat = DateFormat("dd/MM/yyyy");
    _userInfo = ModalRoute.of(context).settings.arguments;
    _isMe = _userInfo.id == AccessInfo().userInfo.id;
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
                expandedHeight: screenSize.height * 0.65,
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
                                _nameTextController.text = _userInfo.fullName;
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
                                  _userInfo.fullName,
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
                              title: Text(_userInfo.email),
                              trailing: _isHideIcon || _isMe
                                  ? null
                                  : IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () async {
                                        await canLaunch(
                                                "mailto:${_userInfo.phoneNumber}?subject=&body=")
                                            ? await launch(
                                                "mailto:${_userInfo.phoneNumber}?subject=&body=")
                                            : throw 'Could not launch mailto:${_userInfo.phoneNumber}?subject=&body=';
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
                                  : Text(_userInfo.phoneNumber == null
                                      ? ""
                                      : _userInfo.phoneNumber),
                              trailing: _isHideIcon || _isMe
                                  ? null
                                  : IconButton(
                                      icon: Icon(
                                        Icons.call,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () async {
                                        await canLaunch(
                                                "tel:${_userInfo.phoneNumber}")
                                            ? await launch(
                                                "tel:${_userInfo.phoneNumber}")
                                            : throw "Could not launch tel:${_userInfo.phoneNumber}";
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
                                    color: Colors.deepOrange,
                                  ),
                            title: Text(
                                _dob == null ? "" : dateFormat.format(_dob)),
                            trailing: _isEditing
                                ? _isHideIcon
                                    ? null
                                    : IconButton(
                                        onPressed: modifyDob,
                                        icon: Icon(
                                          AppIcons.calendar_day,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                : null,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: _isHideIcon
                                ? null
                                : Icon(
                                    Icons.location_on,
                                    color: Colors.pink,
                                  ),
                            title: Text(_userInfo.address == null
                                ? ""
                                : _userInfo.address.toString()),
                            trailing: _isEditing
                                ? _isHideIcon
                                    ? null
                                    : IconButton(
                                        onPressed: modifyAddress,
                                        icon: Icon(
                                          Icons.map,
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
