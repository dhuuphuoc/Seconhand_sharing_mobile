import 'package:flutter/cupertino.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class Validator {
  static String validateEmail(String email) {
    RegExp regExp = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return email.isEmpty
        ? S.current.emptyEmailError
        : regExp.hasMatch(email)
        ? null
        : S.current.invalidEmail;
  }
  static String validatePassword(String password) {
    RegExp regExp = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return password.isEmpty
        ? S.current.emptyPasswordError
        : regExp.hasMatch(password)
        ? null
        : S.current.validatePassword;
  }
}