import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/access_data/access_data.dart';
import 'package:secondhand_sharing/models/enums/member_role/member_role.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/group/group_detail_screen/description_tab/description_tab.dart';
import 'package:secondhand_sharing/screens/group/group_detail_screen/member_tab/member_tab.dart';
import 'package:secondhand_sharing/screens/keys/keys.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/widgets/images_picker/images_picker.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';
import 'dart:ui' as ui;

class GroupDetailScreen extends StatefulWidget {
  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> with SingleTickerProviderStateMixin {
  GroupDetail _groupDetail = GroupDetail();
  MemberRole _role;
  ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  Size _imageSize;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _isLoading = true;
      });
      GroupDetail groupDetail = await GroupServices.getGroupDetail(_groupDetail.id);
      _imageSize = await calculateAvatarSize(groupDetail.avatarUrl);
      var role = await GroupServices.getMemberRole(AccessInfo().userInfo.id, _groupDetail.id);
      setState(() {
        _role = role;
        _groupDetail = groupDetail;
        _isLoading = false;
      });
    });

    super.initState();
  }

  Future<Size> calculateAvatarSize(String avatarUrl) async {
    Image image = avatarUrl == null ? Image.asset('assets/images/group.png') : Image.network(avatarUrl);
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _) {
      if (!completer.isCompleted) completer.complete(info.image);
    }));
    var value = await completer.future;
    return Size(value.width.toDouble(), value.height.toDouble());
  }

  void updateAvatar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImagesPicker();
      },
    ).then((value) {
      if (value != null) {
        GroupServices.updateAvatar(_groupDetail.id, value).then((value) {
          if (value != null) {
            calculateAvatarSize(value).then((size) {
              setState(() {
                _imageSize = size;
                _groupDetail.avatarUrl = value;
              });
            });
          }
        });
      }
    });
  }

  void changeRole(MemberRole role) {
    setState(() {
      _role = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _groupDetail.id = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          key: Keys.groupScreenNestedScrollViewKey,
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  expandedHeight: _imageSize == null ? 0 : _imageSize.height * screenSize.width / _imageSize.width,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(bottom: kToolbarHeight + 10, left: 20),
                    title: Text(
                      _groupDetail.groupName ?? "",
                    ),
                    background: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: kToolbarHeight),
                          child: _groupDetail.avatarUrl == null
                              ? Image.asset(
                                  "assets/images/group.png",
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  _groupDetail.avatarUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          // height: kToolbarHeight,
                          margin: EdgeInsets.only(bottom: kToolbarHeight),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xB0000000),
                              Color(0x00000000),
                              Color(0x00000000),
                              Color(0x00000000),
                              Color(0x00000000),
                              Color(0xB0000000)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                          ),
                        ),
                        if (_role == MemberRole.admin)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: EdgeInsets.only(bottom: kToolbarHeight),
                              child: IconButton(
                                onPressed: updateAvatar,
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  centerTitle: true,
                  floating: true,
                  pinned: true,
                  bottom: TabBar(
                    labelPadding: EdgeInsets.zero,
                    tabs: [
                      Tab(text: S.of(context).posts),
                      Tab(text: S.of(context).description),
                      Tab(text: S.of(context).member),
                    ],
                  ),
                ),
              )
            ];
          },
          body: _isLoading
              ? Center(
                  child: MiniIndicator(),
                )
              : TabBarView(children: [
                  Container(),
                  DescriptionTab(_groupDetail.description),
                  MemberTab(_groupDetail.id, _role, changeRole),
                ]),
        ),
      ),
    );
  }
}
