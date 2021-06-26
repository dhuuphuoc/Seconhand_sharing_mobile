import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item/item.dart';
import 'package:secondhand_sharing/widgets/item_card/item_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';
import 'package:secondhand_sharing/widgets/notification_card/notification_card.dart';

class UserDonationsTab extends StatefulWidget {
  final int userId;

  UserDonationsTab(this.userId);

  @override
  _UserRequestsTabState createState() => _UserRequestsTabState();
}

class _UserRequestsTabState extends State<UserDonationsTab> {
  List<Item> _items = [];
  int _pageNumber = 1;
  int _pageSize = 8;
  bool _isLoading = true;
  bool _isEnd = false;
  ScrollController _postsScrollController;
  @override
  void initState() {
    fetchItems();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _postsScrollController.addListener(() {
        if (_postsScrollController.position.maxScrollExtent ==
            _postsScrollController.offset) {
          if (!_isEnd && !_isLoading) {
            _pageNumber++;
            fetchItems();
          }
        }
      });
    });
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchItems() async {
    setState(() {
      _isLoading = true;
    });
    var items = await ItemServices.getDonatedItems(
        widget.userId, _pageNumber, _pageSize);
    if (items.isEmpty) {
      setState(() {
        _isEnd = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _items.addAll(items);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _postsScrollController = PrimaryScrollController.of(context);

    var listViewWidgets = <Widget>[];

    _items.forEach((item) {
      listViewWidgets.add(ItemCard(item));
    });
    listViewWidgets.add(_isLoading
        ? Container(
            height: screenSize.height * 0.2,
            child: Center(
              child: MiniIndicator(),
            ),
          )
        : Container(
            height: _isEnd ? 0 : screenSize.height * 0.2,
          ));
    if (_isEnd) {
      listViewWidgets.add(NotificationCard(
          Icons.check_circle_outline, S.of(context).endNotifyMessage));
      listViewWidgets.add(SizedBox(height: 10));
    }

    return CustomScrollView(slivers: [
      SliverList(delegate: SliverChildListDelegate(listViewWidgets))
    ]);
  }
}
