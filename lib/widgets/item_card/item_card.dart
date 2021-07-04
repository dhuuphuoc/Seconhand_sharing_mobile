import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/item/item.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';

enum ItemAction { edit, delete }

class ItemCard extends StatelessWidget {
  final Item item;
  final Function onDelete;

  ItemCard(this.item, this.onDelete);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/item/detail", (route) => route.settings.name == "/item/detail" ? false : true,
              arguments: item.id);
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                trailing: item.donateAccountId == AccessInfo().userInfo.id
                    ? PopupMenuButton<ItemAction>(
                        onSelected: (action) {
                          if (action == ItemAction.delete) {
                            ItemServices.deleteItem(item.id).then((value) {
                              if (value) {
                                onDelete();
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        NotifyDialog(S.of(context).failed, S.of(context).deleteItemFailedMessage, "OK"));
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
                      )
                    : null,
                subtitle: Text(
                  "${TimeAgo.parse(item.postTime, locale: Localizations.localeOf(context).languageCode)}",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
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
                  item.imageUrl == null ? "https://i.stack.imgur.com/y9DpT.jpg" : item.imageUrl,
                  gaplessPlayback: true,
                  frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
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
