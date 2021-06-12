import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/user_model/access_info/access_info.dart';
import 'package:secondhand_sharing/models/user_model/user_info_model/user_info/user_info.dart';
import 'package:secondhand_sharing/screens/profile/profile_screen/local_widgets/images_picker/images_picker.dart';
import 'package:secondhand_sharing/screens/profile/user_donations_tab/user_donations_tab.dart';
import 'package:secondhand_sharing/screens/profile/user_requests_tab/user_requests_tab.dart';
import 'package:secondhand_sharing/services/api_services/user_services/user_services.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  DateTime _dob;
  ScrollDirection _scrollDirection = ScrollDirection.idle;
  bool _isHideIcon = false;
  bool _isMe = true;
  bool _isNameEditing = false;
  bool _isPhoneEditing = false;
  bool _isUpdating = false;
  UserInfo _userInfo = UserInfo();
  var _nameTextController = TextEditingController();
  var _phoneTextController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) super.setState(fn);
  }

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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _isUpdating = true;
      });
      if (_isMe) {
        await UserServices.getUserInfo();
        setState(() {
          _userInfo = AccessInfo().userInfo;
        });
      } else {
        var userInfo = await UserServices.getUserInfoById(_userInfo.id);
        if (userInfo != null) {
          setState(() {
            _userInfo = userInfo;
          });
        }
      }
      setState(() {
        _dob = _userInfo.dob;
        _nameTextController.text = _userInfo.fullName;
        _phoneTextController.text = _userInfo.phoneNumber;
        _isUpdating = false;
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
      if (_scrollController.position.minScrollExtent == _scrollController.offset) {
        setState(() {
          _isHideIcon = false;
        });
      }
    });
  }

  void modifyDob() {
    showDatePicker(context: context, initialDate: _dob, firstDate: DateTime.utc(1), lastDate: DateTime.now())
        .then((value) {
      setState(() {
        _isUpdating = true;
      });
      if (value != null) {
        UserServices.updateUserInfo(UpdateProfileForm(dob: value)).then((response) {
          if (response != null) {
            setState(() {
              _dob = response.dob;
            });
          }
          setState(() {
            _isUpdating = false;
          });
        });
      }
    });
  }

  void editName() {
    if (_isNameEditing) {
      setState(() {
        _isUpdating = true;
      });
      UpdateProfileForm form = UpdateProfileForm(fullName: _nameTextController.text);
      UserServices.updateUserInfo(form).then((value) {
        if (value != null) {
          _userInfo.fullName = value.fullName;
          setState(() {
            _nameTextController.text = value.fullName;
          });
        }
        setState(() {
          _isUpdating = false;
        });
      });
    }
    setState(() {
      _isNameEditing = !_isNameEditing;
    });
  }

  void modifyAddress() {
    AddressModel backup = AddressModel.clone(_userInfo.address);
    Navigator.pushNamed(context, "/item/address", arguments: _userInfo.address).then((value) {
      setState(() {
        _isUpdating = true;
      });
      if (value != null)
        UserServices.updateUserInfo(UpdateProfileForm(address: value)).then((response) {
          if (response != null) {
            setState(() {
              _userInfo.address = response.address;
            });
          }
          setState(() {
            _isUpdating = false;
          });
        });
      else {
        setState(() {
          _userInfo.address = backup;
        });
      }
    });
  }

  void editPhoneNumber() {
    if (_isPhoneEditing) {
      setState(() {
        _isUpdating = true;
      });
      UpdateProfileForm form = UpdateProfileForm(phoneNumber: _phoneTextController.text);
      UserServices.updateUserInfo(form).then((value) {
        if (value != null) {
          _userInfo.phoneNumber = value.phoneNumber;
          setState(() {
            _phoneTextController.text = value.phoneNumber;
          });
        }
        setState(() {
          _isUpdating = false;
        });
      });
    }
    setState(() {
      _isPhoneEditing = !_isPhoneEditing;
    });
  }

  void call() async {
    await canLaunch("tel:${_userInfo.phoneNumber}")
        ? await launch("tel:${_userInfo.phoneNumber}")
        : throw "Could not launch tel:${_userInfo.phoneNumber}";
  }

  void pickImages() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImagesPicker();
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _isUpdating = true;
        });
        UserServices.uploadAvatar(value).then((value) {
          if (value != null) {
            setState(() {
              _userInfo.avatarUrl = value;
              _isUpdating = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    var dateFormat = DateFormat("dd/MM/yyyy");
    _userInfo.id = ModalRoute.of(context).settings.arguments as int;
    _isMe = _userInfo.id == AccessInfo().userInfo.id;
    return Scaffold(
        body: NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, value) {
        return [
          SliverAppBar(
            // Provide a standard title.
            expandedHeight: screenSize.height * 0.62,
            actions: [
              if (!_isMe)
                TextButton(
                    onPressed: _isUpdating
                        ? null
                        : () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/chat", (route) => route.settings.name == "/chat" ? false : true,
                                arguments: _userInfo);
                          },
                    child: Text(S.of(context).sendMessage))
            ],
            title: Text(
              S.of(context).profile,
              style: Theme.of(context).textTheme.headline2,
            ),
            centerTitle: true,
            flexibleSpace: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: kToolbarHeight + statusBarHeight),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: screenSize.height * 0.2,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              CircleAvatar(
                                radius: screenSize.height * 0.1,
                                foregroundImage: _userInfo.avatarUrl == null
                                    ? AssetImage("assets/images/person.png")
                                    : NetworkImage(_userInfo.avatarUrl),
                              ),
                              if (!_isHideIcon)
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(onPressed: pickImages, icon: Icon(Icons.camera_alt)))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: IntrinsicWidth(
                              child: _isHideIcon
                                  ? null
                                  : TextFormField(
                                      controller: _nameTextController,
                                      readOnly: !_isNameEditing,
                                      onEditingComplete: editName,
                                      decoration: InputDecoration(
                                        border: _isNameEditing ? UnderlineInputBorder() : InputBorder.none,
                                        prefixIcon: _isMe
                                            ? Visibility(visible: false, child: Icon(Icons.text_rotation_none))
                                            : null,
                                        suffixIcon: _isMe
                                            ? IconButton(
                                                onPressed: editName,
                                                icon: Icon(
                                                  _isNameEditing ? Icons.done : Icons.edit,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              )
                                            : null,
                                      ),
                                      style: Theme.of(context).textTheme.headline2,
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          )),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: ListTile(
                            leading: _isHideIcon
                                ? null
                                : Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            title: Text(_userInfo.email == null ? "" : _userInfo.email),
                            trailing: _isHideIcon || _isMe
                                ? null
                                : IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () async {
                                      await canLaunch("mailto:${_userInfo.email}?subject=&body=")
                                          ? await launch("mailto:${_userInfo.email}?subject=&body=")
                                          : throw 'Could not launch mailto:${_userInfo.email}?subject=&body=';
                                    },
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          leading: _isHideIcon
                              ? null
                              : Icon(
                                  Icons.contact_phone,
                                  color: Theme.of(context).primaryColor,
                                ),
                          title: _isPhoneEditing
                              ? _isHideIcon
                                  ? null
                                  : TextFormField(
                                      controller: _phoneTextController,
                                      keyboardType: TextInputType.phone,
                                      onEditingComplete: editPhoneNumber,
                                    )
                              : Text(_userInfo.phoneNumber == null ? "" : _userInfo.phoneNumber),
                          trailing: _isHideIcon
                              ? null
                              : IconButton(
                                  icon: Icon(
                                    !_isMe
                                        ? Icons.call
                                        : _isPhoneEditing
                                            ? Icons.done
                                            : Icons.edit,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () async {
                                    if (_isMe) {
                                      editPhoneNumber();
                                    } else {
                                      call();
                                    }
                                  },
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          leading: _isHideIcon
                              ? null
                              : Icon(
                                  AppIcons.birthday,
                                  color: Colors.deepOrange,
                                ),
                          title: Text(_dob == null ? "" : dateFormat.format(_dob)),
                          trailing: !_isMe || _isHideIcon
                              ? null
                              : IconButton(
                                  onPressed: modifyDob,
                                  icon: Icon(
                                    AppIcons.calendar_day,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          leading: _isHideIcon
                              ? null
                              : Icon(
                                  Icons.location_on,
                                  color: Colors.pink,
                                ),
                          title: Text(
                            _userInfo.address == null ? "" : _userInfo.address.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: !_isMe || _isHideIcon
                              ? null
                              : IconButton(
                                  onPressed: modifyAddress,
                                  icon: Icon(
                                    Icons.map,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isUpdating)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
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
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          UserRequestsTab(_userInfo.id),
          UserDonationsTab(_userInfo.id),
        ],
      ),
    ));
  }
}
