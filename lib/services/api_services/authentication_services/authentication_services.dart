import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/login_model/login_model.dart';
import 'package:secondhand_sharing/models/reset_password_model/reset_password_model.dart';
import 'package:secondhand_sharing/models/signup_model/signup_model.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;

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

  RegisterForm(this._fullName, this._email, this._password);

  String get fullName => _fullName;
  String get email => _email;
  String get password => _password;

  Map<String, dynamic> toJson() => {
        "fullName": _fullName,
        "email": _email,
        "password": _password,
      };
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
  String _email;
  String _token;
  String _password;
  String _confirmPassword;

  ResetPasswordForm(
      this._email, this._token, this._password, this._confirmPassword);

  String get email => _email;
  String get token => _token;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  Map<String, dynamic> toJson() => {
        "email": _email,
        "token": _token,
        "password": _password,
        "confirmPassword": _confirmPassword,
      };
}

class AuthenticationService {
  static Uri _loginUri = Uri.https(APIService.apiUrl, "/Identity/authenticate");
  static Future<LoginModel> login(LoginForm loginForm) async {
    var response = await http.post(_loginUri,
        body: jsonEncode(loginForm.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    print(jsonEncode(loginForm.toJson()));
    if (response.statusCode == 200) {
      return LoginModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Uri _registerUri = Uri.https(APIService.apiUrl, "/Identity/register");
  static Future<RegisterModel> register(RegisterForm registerForm) async {
    var response = await http.post(_registerUri,
        body: jsonEncode(registerForm.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    if (response.statusCode == 200) {
      return RegisterModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Uri _forgotPasswordUri =
      Uri.https(APIService.apiUrl, "/Identity/forgot-password");
  static Future<int> forgotPassword(
      ForgotPasswordForm forgotPasswordForm) async {
    var response = await http.post(_forgotPasswordUri,
        body: jsonEncode(forgotPasswordForm.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    return response.statusCode;
  }

  static Uri _resetPasswordUri =
      Uri.https(APIService.apiUrl, "/Identity/reset-password");
  static Future<ResetPasswordModel> resetPassword(
      ResetPasswordForm resetPasswordForm) async {
    var response = await http.post(_resetPasswordUri,
        body: jsonEncode(resetPasswordForm.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      return ResetPasswordModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
