import 'package:secondhand_sharing/models/address_model/district/district.dart';

class Province {
  int _id;
  String _name;
  Map<int, District> districts = {};

  int get id => _id;

  String get name => _name;

  Province(this._id, this._name);
}
