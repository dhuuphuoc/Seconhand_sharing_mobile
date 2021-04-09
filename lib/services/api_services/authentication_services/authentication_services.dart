import 'dart:convert';

import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:http/http.dart' as http;

class LoginForm {
  String _username;
  String _password;

  LoginForm(this._username, this._password);

  String get password => _password;

  String get username => _username;

  Map<String, dynamic> toJson() => {
        "username": _username,
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

class AuthenticationService {
  static Uri loginUri = Uri.parse(APIService.apiUrl + "/Identity/authenticate");

  static Future<int> login(LoginForm loginForm) async {
    var response = await http.post(loginUri,
        body: jsonEncode(loginForm.toJson()),
        headers: {"Content-Type": "application/json"});
    return response.statusCode;
  }

  static Uri registerUri = Uri.https(APIService.apiUrl, "/Identity/register");

  static Future<int> register(RegisterForm registerForm) async {
    var response = await http.post(registerUri,
        body: jsonEncode(registerForm.toJson()),
        headers: {"Content-Type": "application/json"});
    print(response.body);
    return response.statusCode;
  }
}
