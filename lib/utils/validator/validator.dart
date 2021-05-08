import 'dart:io';

import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country.dart';
import 'package:secondhand_sharing/models/address_model/country_model/country_data.dart';
import 'package:secondhand_sharing/models/address_model/district/district.dart';
import 'package:secondhand_sharing/models/address_model/province/province.dart';
import 'package:secondhand_sharing/models/address_model/ward/ward.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';

class Validator {
  static String validateUsername(String username) {
    return username.length < 6 ? S.current.invalidUsername : null;
  }

  static String validateAddressModel(AddressModel addressModel) {
    if (addressModel.province == null || addressModel.district == null)
      return S.current.addressError;
    if (addressModel.ward == null) {
      if (addressModel.district.wards.length == 0) return null;
      return S.current.addressError;
    }
  }

  static String validateImages(Map<String, ImageData> images) {
    return images.length > 0 ? null : S.current.notEnoughImages;
  }

  static String validateEmail(String email) {
    RegExp regExp = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return email.isEmpty
        ? S.current.emptyEmailError
        : regExp.hasMatch(email)
            ? null
            : S.current.invalidEmail;
  }

  static String validatePassword(String password) {
    // RegExp regExp = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return password.isEmpty
        ? S.current.emptyPasswordError
        // : regExp.hasMatch(password)
        : password.length > 8
            ? null
            : S.current.validatePassword;
  }

  static String validatePhoneNumber(String phoneNumber) {
    RegExp regExp = new RegExp(r"^(0)?[0-9]{10}$");
    return regExp.hasMatch(phoneNumber) ? null : S.current.invalidPhoneNumber;
  }

  static String validateTitle(String title) {
    return title.length == 0 ? S.current.titleEmptyError : null;
  }

  static String validateDescription(String description) {
    return description.length == 0 ? S.current.descriptionEmptyError : null;
  }

  static String matchPassword(String confirmPassword, String password) {
    return (confirmPassword == password) ? null : S.current.matchPassword;
  }
}
