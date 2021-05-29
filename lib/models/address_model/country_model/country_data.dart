import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country.dart';
import 'package:secondhand_sharing/models/address_model/district/district.dart';
import 'package:secondhand_sharing/models/address_model/province/province.dart';
import 'package:secondhand_sharing/models/address_model/ward/ward.dart';

Future<Map<int, Province>> loadProvinceData(String filePath) async {
  var data = await rootBundle.loadString(filePath, cache: true);
  return compute(parseData, data);
}

Map<int, Province> parseData(String data) {
  Map<int, Province> provinces = {};
  var lines = data.split("\n");
  Province currentProvince = Province(0, "");
  District currentDistrict = District(0, "");

  for (int i = 1; i < lines.length - 1; i++) {
    var row = lines[i].split(",");
    // create province
    int provinceId = int.tryParse(row[6]);
    String provinceName =
        row[7].replaceFirst("Tỉnh ", "").replaceFirst("Thành phố ", "");
    if (provinceId != currentProvince.id) {
      Province province = Province(provinceId, provinceName);
      provinces[provinceId] = province;
      currentProvince = province;
    }
    //create district
    int districtId = int.tryParse(row[4]);
    String districtName = row[5];
    if (districtId != currentDistrict.id) {
      District district = District(districtId, districtName);
      currentProvince.districts[districtId] = district;
      currentDistrict = district;
    }
    //create ward
    int wardId = int.tryParse(row[0]);
    if (wardId == null) continue;
    String wardName = row[1];
    Ward ward = Ward(wardId, wardName);
    currentDistrict.wards[wardId] = ward;
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
