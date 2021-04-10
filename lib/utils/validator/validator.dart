import 'package:secondhand_sharing/generated/l10n.dart';

class Validator {
  static String validateUsername(String username) {
    return username.length < 6 ? S.current.invalidUsername : null;
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

  static String matchPassword(String confirmPassword, String password) {
    return  (confirmPassword == password)
        ? null
        : S.current.matchPassword;
  }
}
