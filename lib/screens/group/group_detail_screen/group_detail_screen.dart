import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group/group.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';

class GroupDetailScreen extends StatefulWidget {
  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  GroupDetail _groupDetail = GroupDetail();
  int _groupId;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      GroupDetail groupDetail = await GroupServices.getGroupDetail(_groupId);
      setState(() {
        _groupDetail = groupDetail;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _groupId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _groupDetail.groupName != null
              ? _groupDetail.groupName.toUpperCase()
              : S.of(context).groupName,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          },
        ),
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 15),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DefaultTabController(
                length: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: TabBar(
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(text: S.of(context).post),
                          Tab(text: S.of(context).description),
                          Tab(text: S.of(context).rule),
                          Tab(text: S.of(context).member)
                        ],
                      ),
                    ),
                    Container(
                      height: 600,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5))),
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                            child: Text(
                              S.of(context).all,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Container(
                            child: Text(
                              _groupDetail.description != null
                                  ? _groupDetail.description
                                  : S.of(context).description,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Container(
                            child: Text(
                              _groupDetail.rules != null
                                  ? _groupDetail.rules
                                  : S.of(context).rule,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Container(
                            child: Text(
                              S.of(context).member,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
