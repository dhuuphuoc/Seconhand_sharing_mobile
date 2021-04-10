import 'dart:convert';
import 'dart:io';

import 'package:secondhand_sharing/models/login_model/login_model.dart';
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

class AuthenticationService {
  static Uri _loginUri = Uri.https(APIService.apiUrl, "/Identity/authenticate");
  static Future<LoginModel> login(LoginForm loginForm) async {
    var response = await http.post(_loginUri,
        body: jsonEncode(loginForm.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    print(jsonEncode(loginForm.toJson()));
    LoginModel loginModel = LoginModel.fromJson(jsonDecode(response.body));
    return loginModel;
  }

  static Uri _registerUri = Uri.https(APIService.apiUrl, "/Identity/register");
  static Future<RegisterModel> register(RegisterForm registerForm) async {
    var response = await http.post(_registerUri,
        body: jsonEncode(registerForm.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    RegisterModel registerModel = RegisterModel.fromJson(jsonDecode(response.body));
    return registerModel;
  }

  static Uri _forgotPasswordUri = Uri.https(APIService.apiUrl, "/Identity/forgot-password");
  static Future<int> forgotPassword(ForgotPasswordForm forgotPasswordForm) async {
    var response = await http.post(_forgotPasswordUri,
      headers: {HttpHeaders.contentTypeHeader: "application/json"});
    return response.statusCode;
  }
}
