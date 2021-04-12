import 'package:secondhand_sharing/models/address_model/district/district.dart';
import 'package:secondhand_sharing/models/address_model/province/province.dart';
import 'package:secondhand_sharing/models/address_model/ward/ward.dart';

class AddressModel {
  String address;
  Ward ward;
  District district;
  Province province;

  Map<String, dynamic> toJson() => {
        "streetNumber": 1,
        "street": address,
        "wardId": ward.id,
        "districtId": district.id,
        "cityId": province.id,
      };

  @override
  String toString() {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write(address == null ? "" : address.trim());
    stringBuffer.write(address == null || address == "" ? "" : ", ");
    stringBuffer.write(ward == null
        ? ""
        : ward.name
            .replaceFirst("Phường ", "P.")
            .replaceFirst("Thị trấn", "TT."));
    stringBuffer.write(ward == null ? "" : ", ");
    stringBuffer.write(district == null
        ? ""
        : district.name
            .replaceFirst("Quận ", "Q.")
            .replaceFirst("Huyện ", "H."));
    stringBuffer.write(district == null ? "" : ", ");
    stringBuffer.write(province == null
        ? ""
        : province.name.replaceFirst("Thành phố ", "TP."));
    return stringBuffer.toString();
  }
}
