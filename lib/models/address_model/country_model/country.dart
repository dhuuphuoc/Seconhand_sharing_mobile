import 'package:secondhand_sharing/models/address_model/province/province.dart';

class Country {
  int _id;
  String _name;
  List<Province> _provinces = [];

  int get id => _id;

  Country(this._id, this._name, this._provinces);

  List<Province> get provinces => _provinces;

  String get name => _name;
}
