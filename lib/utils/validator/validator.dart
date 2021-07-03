import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';

class Validator {
  static String validateUsername(String username) {
    return username.length < 6 ? S.current.invalidUsername : null;
  }

  static String validateAddressModel(AddressModel addressModel) {
    if (addressModel.province == null || addressModel.district == null) return S.current.addressError;
    if (addressModel.ward == null) {
      if (addressModel.district.wards.length == 0) return null;
      return S.current.addressError;
    }
    return null;
  }

  static String validateImages(List<ImageData> images) {
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
    RegExp regExp = new RegExp(r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$");
    return password.isEmpty
        ? S.current.emptyPasswordError
        : regExp.hasMatch(password)
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

  static String validateGroupName(String groupName) {
    return groupName.length == 0 ? S.current.groupNameEmptyError : null;
  }

  static String validateRule(String rule) {
    return rule.length == 0 ? S.current.ruleEmptyError : null;
  }

  static String matchPassword(String confirmPassword, String password) {
    return (confirmPassword == password) ? null : S.current.matchPassword;
  }

  static String validateEventName(String value) {
    return value.length == 0 ? S.current.eventNameEmptyError : null;
  }

  static String validateStartDate(String value) {
    return value.length == 0 ? S.current.startDateEmptyError : null;
  }

  static String validateEndDate(String value) {
    return value.length == 0 ? S.current.endDateEmptyError : null;
  }

  static String validateContent(String value) {
    return value.length == 0 ? S.current.contentEmptyError : null;
  }
}
