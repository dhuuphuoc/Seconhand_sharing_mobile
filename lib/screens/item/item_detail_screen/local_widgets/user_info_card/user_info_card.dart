import 'package:flutter/material.dart';
import 'package:secondhand_sharing/models/address_model/address_model.dart';

class UserInfoCard extends StatefulWidget {
  final String _name;
  final String _avatarUrl;
  final AddressModel _addressModel;
  final Function _onMapPress;

  UserInfoCard(this._name, this._avatarUrl, this._addressModel, this._onMapPress);

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 10),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: CircleAvatar(
                    maxRadius: 25,
                    foregroundImage: widget._avatarUrl == null
                        ? AssetImage("assets/images/person.png")
                        : NetworkImage(widget._avatarUrl),
                    backgroundColor: Colors.transparent),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        widget._name,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.pink),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget._addressModel.toString(),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: Icon(Icons.contact_phone_outlined),
                  onPressed: widget._onMapPress,
                ),
              ),
            ],
          ),
        ));
  }
}
