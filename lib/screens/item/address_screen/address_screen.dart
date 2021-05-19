import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country_data.dart';
import 'package:secondhand_sharing/models/address_model/district/district.dart';
import 'package:secondhand_sharing/models/address_model/province/province.dart';
import 'package:secondhand_sharing/models/address_model/ward/ward.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  Country _vn = CountryData().vn;
  AddressModel _addressModel;

  int compareProvinces(Province p1, Province p2) {
    return p1.name.compareTo(p2.name);
  }

  int compareWards(Ward ward1, Ward ward2) {
    return ward1.name.compareTo(ward2.name);
  }

  int compareDistricts(District district1, District district2) {
    return district1.name.compareTo(district2.name);
  }

  @override
  Widget build(BuildContext context) {
    if (_addressModel == null) {
      _addressModel = ModalRoute.of(context).settings.arguments as AddressModel;
      _addressController.text = _addressModel.address;
    }
    List<Province> provinces = _vn.provinces.values.toList();
    provinces.sort(compareProvinces);

    List<District> districts = _addressModel.province == null
        ? []
        : _addressModel.province.districts.values.toList();
    districts.sort(compareDistricts);

    List<Ward> wards = _addressModel.district == null
        ? []
        : _addressModel.district.wards.values.toList();
    wards.sort(compareWards);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).receiveAddress,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (String address) {
                      return address.length == 0
                          ? S.current.addressEmptyError
                          : null;
                    },
                    onChanged: (text) {
                      _addressModel.address = text;
                    },
                    controller: _addressController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: S.of(context).addressHint,
                        labelText: S.of(context).address),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<Province>(
                    validator: (Province province) {
                      return province == null
                          ? S.current.provinceEmptyError
                          : null;
                    },
                    value: _addressModel.province,
                    hint: Text(S.of(context).province),
                    onChanged: (province) {
                      setState(() {
                        _addressModel.province = province;
                        _addressModel.district = null;
                        _addressModel.ward = null;
                      });
                    },
                    items: provinces
                        .map<DropdownMenuItem<Province>>(
                            (province) => DropdownMenuItem<Province>(
                                  value: province,
                                  child: Text(province.name),
                                ))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<District>(
                    validator: (District district) {
                      return district == null
                          ? S.current.districtEmptyError
                          : null;
                    },
                    value: _addressModel.district,
                    elevation: 16,
                    hint: Text(S.of(context).district),
                    onChanged: (district) {
                      setState(() {
                        _addressModel.district = district;
                        _addressModel.ward = null;
                      });
                    },
                    items: districts
                        .map<DropdownMenuItem<District>>(
                            (district) => DropdownMenuItem<District>(
                                  value: district,
                                  child: Text(district.name),
                                ))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<Ward>(
                    validator: (Ward ward) {
                      if (_addressModel.district.wards.length == 0) return null;
                      return ward == null ? S.current.wardEmptyError : null;
                    },
                    value: _addressModel.ward,
                    hint: Text(S.of(context).ward),
                    onChanged: (ward) {
                      setState(() {
                        _addressModel.ward = ward;
                        print(ward);
                      });
                    },
                    items: wards
                        .map<DropdownMenuItem<Ward>>(
                            (ward) => DropdownMenuItem<Ward>(
                                  value: ward,
                                  child: Text(ward.name),
                                ))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState.validate()) return;
                          Navigator.pop(context, _addressModel);
                        },
                        child: Text(S.of(context).confirm)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
