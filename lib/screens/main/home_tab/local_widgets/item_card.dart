import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item_model/item.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  ItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/item/detail", arguments: item.id);
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: CircleAvatar(
                  foregroundImage: AssetImage("assets/images/person.png"),
                  backgroundColor: Theme.of(context).backgroundColor,
                ),
                title: Text(
                  item.donateAccountName,
                  style: Theme.of(context).textTheme.headline3,
                ),
                subtitle: Text(
                    "${TimeAgo.parse(item.postTime, locale: Localizations.localeOf(context).languageCode)}"),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  item.itemName,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, bottom: 10),
                child: Text(
                  item.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
              Divider(
                height: 3,
                thickness: 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  "${S.of(context).receiveAddress}:\n${item.receiveAddress}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
