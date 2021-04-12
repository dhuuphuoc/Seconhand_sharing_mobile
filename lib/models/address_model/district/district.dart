import 'package:secondhand_sharing/models/address_model/ward/ward.dart';

class District {
  int _id;
  String _name;
  Map<int, Ward> wards = {};

  int get id => _id;

  String get name => _name;

  District(this._id, this._name);
}
