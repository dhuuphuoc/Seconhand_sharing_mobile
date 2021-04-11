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

  @override
  Widget build(BuildContext context) {
    if (_addressModel == null) {
      _addressModel = ModalRoute.of(context).settings.arguments as AddressModel;
      _addressController.text = _addressModel.address;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).receiveAddress,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<Province>(
                    validator: Validator.validateProvince,
                    value: _addressModel.province,
                    hint: Text(S.of(context).province),
                    onChanged: (province) {
                      setState(() {
                        _addressModel.province = province;
                        _addressModel.district = null;
                        _addressModel.ward = null;
                      });
                    },
                    items: _vn.provinces
                        .map<DropdownMenuItem<Province>>(
                            (province) => DropdownMenuItem<Province>(
                                  value: province,
                                  child: Text(province.name),
                                ))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<District>(
                    validator: Validator.validateDistrict,
                    value: _addressModel.district,
                    elevation: 16,
                    hint: Text(S.of(context).district),
                    onChanged: (district) {
                      setState(() {
                        _addressModel.district = district;
                        _addressModel.ward = null;
                      });
                    },
                    items: _addressModel.province != null
                        ? _addressModel.province.districts
                            .map<DropdownMenuItem<District>>(
                                (district) => DropdownMenuItem<District>(
                                      value: district,
                                      child: Text(district.name),
                                    ))
                            .toList()
                        : [],
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<Ward>(
                    validator: Validator.validateWard,
                    value: _addressModel.ward,
                    hint: Text(S.of(context).ward),
                    onChanged: (ward) {
                      setState(() {
                        _addressModel.ward = ward;
                      });
                    },
                    items: _addressModel.district != null
                        ? _addressModel.district.wards
                            .map<DropdownMenuItem<Ward>>(
                                (ward) => DropdownMenuItem<Ward>(
                                      value: ward,
                                      child: Text(ward.name),
                                    ))
                            .toList()
                        : [],
                  ),
                  TextFormField(
                    validator: Validator.validateAddress,
                    controller: _addressController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: S.of(context).addressHint,
                        labelText: S.of(context).address),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState.validate()) return;
                          _addressModel.address = _addressController.text;
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
