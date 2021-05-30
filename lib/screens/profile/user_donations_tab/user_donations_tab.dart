import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/screens/main/home_tab/local_widgets/item_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';

class UserDonationsTab extends StatefulWidget {
  final int userId;

  UserDonationsTab(this.userId);

  @override
  _UserRequestsTabState createState() => _UserRequestsTabState();
}

class _UserRequestsTabState extends State<UserDonationsTab> {
  List<Item> _items = [];
  int _pageNumber = 1;
  bool _isLoading = true;
  bool _isEnd = false;
  ScrollController _postsScrollController;
  @override
  void initState() {
    fetchItems();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _postsScrollController.addListener(() {
        if (_postsScrollController.position.maxScrollExtent == _postsScrollController.offset) {
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
    var items = await ItemServices.getDonatedItems(widget.userId, _pageNumber);
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
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            height: _isEnd ? 0 : screenSize.height * 0.2,
          ));
    if (_isEnd) {
      listViewWidgets.add(Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text(S.of(context).endNotifyMessage),
            SizedBox(height: 10),
          ],
        ),
      ));
    }

    return CustomScrollView(slivers: [SliverList(delegate: SliverChildListDelegate(listViewWidgets))]);
  }
}
