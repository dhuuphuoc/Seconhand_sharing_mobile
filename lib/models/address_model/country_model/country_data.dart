import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country.dart';
import 'package:secondhand_sharing/models/address_model/district/district.dart';
import 'package:secondhand_sharing/models/address_model/province/province.dart';
import 'package:secondhand_sharing/models/address_model/ward/ward.dart';

Future<List<Province>> loadProvinceData(String filePath) async {
  var data = await rootBundle.loadString(filePath, cache: true);
  return compute(parseData, data);
}

List<Province> parseData(String data) {
  List<Province> provinces = [];
  var lines = data.split("\n");
  Province currentProvince = Province(0, "");
  District currentDistrict = District(0, "");

  for (int i = 1; i < lines.length - 1; i++) {
    var row = lines[i].split(",");
    // create province
    int provinceId = int.tryParse(row[6]);
    String provinceName = row[7].replaceFirst("Tỉnh ", "");
    if (provinceId != currentProvince.id) {
      Province provinceNode = Province(provinceId, provinceName);
      provinces.add(provinceNode);
      currentProvince = provinceNode;
    }
    //create district
    int districtId = int.tryParse(row[4]);
    String districtName = row[5];
    if (districtId != currentDistrict.id) {
      District districtNode = District(districtId, districtName);
      currentProvince.districts.add(districtNode);
      currentDistrict = districtNode;
    }
    //create ward
    int wardId = int.tryParse(row[0]);
    String wardName = row[1];
    Ward wardNode = Ward(wardId, wardName);
    currentDistrict.wards.add(wardNode);
  }
  return provinces;
}

class CountryData {
  Country vn;
  static final CountryData _singleton = CountryData._create();

  factory CountryData() {
    return _singleton;
  }

  CountryData._create();
}
