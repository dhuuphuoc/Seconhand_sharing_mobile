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
}