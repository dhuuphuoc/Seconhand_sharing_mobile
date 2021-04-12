import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  ItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/images/person.png"),
                backgroundColor: Theme.of(context).backgroundColor,
              ),
              title: Text(
                item.donateAccountName,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Container(
              child: Image.network(
                item.imageUrl,
                frameBuilder: (BuildContext context, Widget child, int frame,
                    bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded ?? false) {
                    return child;
                  }
                  return AnimatedOpacity(
                    child: child,
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                  );
                },
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: Text(
                item.itemName,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                "${TimeAgo.parse(item.postTime, locale: Localizations.localeOf(context).languageCode)}\n${item.receiveAddress}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Divider(
              height: 3,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                item.description,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
