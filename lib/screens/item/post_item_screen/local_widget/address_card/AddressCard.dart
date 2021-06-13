import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/address_model.dart';

class AddressCard extends StatefulWidget {
  final AddressModel addressModel;
  final Function onMapPress;

  AddressCard(this.addressModel, this.onMapPress);

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.pink,
                size: 36,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            S.of(context).receiveAddress,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        )
                      ],
                    ),
                    Text(
                      widget.addressModel.toString(),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.map_outlined),
                onPressed: widget.onMapPress,
              ),
            ],
          ),
        ));
  }
}
