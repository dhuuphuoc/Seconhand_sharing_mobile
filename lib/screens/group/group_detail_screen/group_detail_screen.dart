import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/screens/group/group_detail_screen/description_tab/description_tab.dart';
import 'package:secondhand_sharing/screens/group/group_detail_screen/member_tab/member_tab.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';

class GroupDetailScreen extends StatefulWidget {
  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  GroupDetail _groupDetail = GroupDetail();
  ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _isLoading = true;
      });
      GroupDetail groupDetail =
          await GroupServices.getGroupDetail(_groupDetail.id);
      setState(() {
        _groupDetail = groupDetail;
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _groupDetail.id = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _groupDetail.groupName ?? "",
            style: Theme.of(context).textTheme.headline2,
          ),
          centerTitle: true,
          bottom: TabBar(
            labelPadding: EdgeInsets.zero,
            tabs: [
              Tab(text: S.of(context).posts),
              Tab(text: S.of(context).description),
              Tab(text: S.of(context).member)
            ],
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(children: [
                Container(),
                DescriptionTab(_groupDetail.description),
                MemberTab(_groupDetail.id),
              ]),
      ),
    );
  }
}
