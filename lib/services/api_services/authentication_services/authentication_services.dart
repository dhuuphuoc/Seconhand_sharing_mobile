import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/access_data/access_data.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:secondhand_sharing/utils/response_deserializer/response_deserializer.dart';

class LoginForm {
  String _email;
  String _password;

  LoginForm(this._email, this._password);

  String get password => _password;

  String get email => _email;

  Map<String, dynamic> toJson() => {
        "email": _email,
        "password": _password,
      };
}

class RegisterForm {
  String _fullName;
  String _email;
  String _password;
  String _dateOfBirth;
  String _phoneNumber;

  RegisterForm(this._fullName, this._email, this._password, this._dateOfBirth, this._phoneNumber);

  String get fullName => _fullName;

  String get email => _email;

  String get password => _password;

  String get dateOfBirth => _dateOfBirth;

  String get phoneNumber => _phoneNumber;

  Map<String, dynamic> toJson() =>
      {"fullName": _fullName, "email": _email, "password": _password, "dob": _dateOfBirth, "phoneNumber": _phoneNumber};
}

class ForgotPasswordForm {
  String _email;

  ForgotPasswordForm(this._email);

  String get email => _email;

  Map<String, dynamic> toJson() => {
        "email": _email,
      };
}

class ResetPasswordForm {
  String _userId;
  String _token;
  String _password;
  String _confirmPassword;

  ResetPasswordForm(this._userId, this._token, this._password, this._confirmPassword);

  String get userId => _userId;

  String get token => _token;

  String get password => _password;

  String get confirmPassword => _confirmPassword;

  Map<String, dynamic> toJson() => {
        "userId": _userId,
        "token": _token,
        "password": _password,
        "confirmPassword": _confirmPassword,
      };
}

class ConfirmEmailForm {
  String _userId;
  String _code;

  ConfirmEmailForm(this._userId, this._code);

  String get userId => _userId;

  String get code => _code;

  Map<String, dynamic> toJson() => {
        "userId": _userId,
        "code": _code,
      };
}

class AuthenticationService {
  static Future<AccessData> login(LoginForm loginForm) async {
    Uri url = Uri.https(APIService.apiUrl, "/Identity/authenticate");
    var response = await http.post(url, body: jsonEncode(loginForm.toJson()), headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    print(response.body);
    return AccessData.fromJson(ResponseDeserializer.deserializeResponse(response));
  }

  static Future<bool> register(RegisterForm registerForm) async {
    Uri url = Uri.https(APIService.apiUrl, "/Identity/register");
    var response = await http.post(url, body: jsonEncode(registerForm.toJson()), headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    return response.statusCode == 200;
  }

  static Future<bool> forgotPassword(ForgotPasswordForm forgotPasswordForm) async {
    Uri url = Uri.https(APIService.apiUrl, "/Identity/forgot-password");
    var response = await http.post(url, body: jsonEncode(forgotPasswordForm.toJson()), headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    return response.statusCode == 200;
  }

  static Future<bool> resetPassword(ResetPasswordForm resetPasswordForm) async {
    Uri url = Uri.https(APIService.apiUrl, "/Identity/reset-password");
    var response = await http.post(url, body: jsonEncode(resetPasswordForm.toJson()), headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    });
    return response.statusCode == 200;
  }

  static Future<bool> confirmEmail(ConfirmEmailForm confirmEmailForm) async {
    Uri url = Uri.https(APIService.apiUrl, "/Identity/confirm-email");
    var response = await http.post(url,
        body: jsonEncode(confirmEmailForm.toJson()), headers: {HttpHeaders.contentTypeHeader: "application/json"});
    return response.statusCode == 200;
  }
}
