import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item_detail_model/item_detail.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/images_view/images_view.dart';
import 'package:secondhand_sharing/screens/item/item_detail_screen/local_widgets/user_info_card/user_info_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';

class ItemDetailScreen extends StatefulWidget {
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  ItemDetail _itemDetail = ItemDetail();
  bool _isLoading = true;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ItemServices.getItemDetail(_itemDetail.id).then((value) {
        if (value != null) {
          setState(() {
            _itemDetail = value;

            _isLoading = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_itemDetail.id == null) {
      _itemDetail.id = ModalRoute.of(context).settings.arguments;
      print(_itemDetail.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).detail,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    UserInfoCard(_itemDetail.receiveAddress, () {}),
                    SizedBox(height: 10),
                    ImagesView(
                      images: _itemDetail.imageUrl,
                      itemName: _itemDetail.itemName,
                    ),
                    SizedBox(height: 10),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${S.of(context).description}:",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(_itemDetail.description),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                          onPressed: () {}, child: Text(S.of(context).request)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
