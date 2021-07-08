import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/enums/item_status/item_status.dart';
import 'package:secondhand_sharing/models/enums/member_role/member_role.dart';
import 'package:secondhand_sharing/models/group_event/group_event.dart';
import 'package:secondhand_sharing/models/item/item.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/main/group_tab/local_widgets/group_avatar/group_avatar.dart';
import 'package:secondhand_sharing/services/api_services/event_services/event_services.dart';
import 'package:secondhand_sharing/services/api_services/group_services/group_services.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/utils/time_remainder/time_remainder.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/dialog/confirm_dialog/confirm_dialog.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
import 'package:secondhand_sharing/widgets/event_card/event_card.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';
import 'package:secondhand_sharing/widgets/item_card/item_card.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';
import 'package:secondhand_sharing/widgets/number_badge/number_badge.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key key}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  GroupEvent _event = GroupEvent();
  int _pageNumber = 1;
  int _pageSize = 10;
  MemberRole _role;
  List<Item> _items = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _isEnd = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    var event = await EventServices.getEventDetail(_event.id);
    _role = await GroupServices.getMemberRole(AccessInfo().userInfo.id, event.groupId);

    if (_role != null) {
      var items = await EventServices.getItems(_event.id, _pageNumber, _pageSize);
      setState(() {
        if (items.length < _pageSize) _isEnd = true;
        _items.addAll(items);
      });
    } else {
      var items = await EventServices.getMyDonations(_event.id, _pageNumber, _pageSize);
      setState(() {
        _isEnd = true;
        _items.addAll(items);
      });
    }
    setState(() {
      _event = event;
      _isLoading = false;
    });
  }

  Future<void> loadMore() async {
    if (_isEnd) return;
    setState(() {
      _isLoadingMore = true;
    });
    var items = await EventServices.getItems(_event.id, _pageNumber, _pageSize);
    setState(() {
      if (items.length < _pageSize) _isEnd = true;
      _items.addAll(items);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _event.id = ModalRoute.of(context).settings.arguments;
    var dateFormat = DateFormat("dd/MM/yyyy");
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).event,
            style: Theme.of(context).textTheme.headline2,
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(
                child: MiniIndicator(),
              )
            : ListView(
                children: [
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GroupAvatar(_event.groupAvatar, 28),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _event.groupName,
                                      style: Theme.of(context).textTheme.headline3,
                                    ),
                                    Text(
                                      "${TimeAgo.parse(_event.startDate, locale: Localizations.localeOf(context).languageCode)}",
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text("${S.of(context).remaining(TimeRemainder.parse(_event.endDate, context))}"),
                                  Text(""),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          Text(
                            _event.eventName,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          ListTile(
                            leading: Icon(
                              AppIcons.calendar,
                              color: Color(0xFFEB2626),
                            ),
                            horizontalTitleGap: 0,
                            contentPadding: EdgeInsets.only(),
                            title: Text("${dateFormat.format(_event.startDate)} - ${dateFormat.format(_event.endDate)}"),
                          ),
                          Text(_event.content),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ExpansionTile(
                      leading: Icon(Icons.app_registration),
                      title: Text(_role == null ? S.of(context).myDonation : S.of(context).donation),
                      initiallyExpanded: _role == null,
                      trailing: NumberBadge(_items.length),
                      children: [
                        ..._items.map((item) => InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/item/detail", arguments: item.id);
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Avatar(item.avatarUrl, 20),
                                    title: Row(
                                      children: [
                                        Text(
                                          item.donateAccountName,
                                          style: Theme.of(context).textTheme.headline3,
                                        ),
                                        if (item.eventName != null) Icon(Icons.arrow_right),
                                        if (item.eventName != null)
                                          Expanded(
                                              child: Text(
                                            item.eventName,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.headline3,
                                          ))
                                      ],
                                    ),
                                    trailing: _role != null
                                        ? Text(
                                            item.status == ItemStatus.accepted
                                                ? S.of(context).accepted
                                                : item.status == ItemStatus.success
                                                    ? S.of(context).took
                                                    : "",
                                            style: TextStyle(color: Colors.green),
                                          )
                                        : PopupMenuButton<ItemAction>(
                                            onSelected: (action) {
                                              if (action == ItemAction.delete) {
                                                ItemServices.deleteItem(item.id).then((value) {
                                                  if (value) {
                                                    setState(() {
                                                      _items.remove(item);
                                                    });
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => NotifyDialog(
                                                            S.of(context).failed, S.of(context).deleteItemFailedMessage, "OK"));
                                                  }
                                                });
                                              }
                                            },
                                            itemBuilder: (context) => <PopupMenuEntry<ItemAction>>[
                                              PopupMenuItem<ItemAction>(
                                                value: ItemAction.edit,
                                                child: ListTile(
                                                    leading: Icon(
                                                      Icons.edit,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                    title: Text(
                                                      S.of(context).edit,
                                                      style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                    )),
                                              ),
                                              PopupMenuItem<ItemAction>(
                                                value: ItemAction.delete,
                                                child: ListTile(
                                                    leading: Icon(
                                                      Icons.delete,
                                                      color: Color(0xFFEB2626),
                                                    ),
                                                    title: Text(
                                                      S.of(context).delete,
                                                      style: TextStyle(color: Color(0xFFEB2626)),
                                                    )),
                                              ),
                                            ],
                                          ),
                                    subtitle: Text(
                                      "${TimeAgo.parse(item.postTime, locale: Localizations.localeOf(context).languageCode)}",
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            item.imageUrl == null ? "https://i.stack.imgur.com/y9DpT.jpg" : item.imageUrl,
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                item.itemName,
                                                style: Theme.of(context).textTheme.headline3,
                                              ),
                                              Text(
                                                "${S.of(context).receiveAddress}:",
                                                style: Theme.of(context).textTheme.bodyText1,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                "${item.receiveAddress.toString()}",
                                                style: Theme.of(context).textTheme.bodyText1,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Divider(
                                                thickness: 2,
                                              ),
                                              Text(
                                                item.description,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (item.status != ItemStatus.success && _role == MemberRole.admin)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => ConfirmDialog(
                                                      S.of(context).reject, S.of(context).rejectItemConfirmation)).then((result) {
                                                if (result == true) {
                                                  EventServices.rejectItem(_event.id, item.id).then((value) {
                                                    if (value) {
                                                      setState(() {
                                                        _items.remove(item);
                                                      });
                                                    }
                                                  });
                                                }
                                              });
                                            },
                                            child: Text(
                                              S.of(context).reject,
                                              style: TextStyle(color: Colors.black54),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        item.status == ItemStatus.notYet
                                            ? TextButton(
                                                onPressed: () {
                                                  EventServices.acceptItem(_event.id, item.id).then((value) {
                                                    if (value) {
                                                      setState(() {
                                                        item.status = ItemStatus.accepted;
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Text(S.of(context).accept))
                                            : TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => ConfirmDialog(S.of(context).cancelAccept,
                                                          S.of(context).cancelAcceptEventItemConfirmation)).then((result) {
                                                    if (result == true) {
                                                      EventServices.cancelAccept(_event.id, item.id).then((value) {
                                                        if (value) {
                                                          setState(() {
                                                            item.status = ItemStatus.notYet;
                                                          });
                                                        }
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Text(S.of(context).cancelAccept)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            )),
                        if (_isLoadingMore) Container(margin: EdgeInsets.symmetric(vertical: 10), child: MiniIndicator()),
                        if (_role != null && !_isEnd)
                          Container(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(onPressed: loadMore, child: Text(S.of(context).seeMore)))
                      ],
                    ),
                  ),
                ],
              ));
  }
}
