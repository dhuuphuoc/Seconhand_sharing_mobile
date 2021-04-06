import 'dart:convert';
import 'dart:io';

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

class AuthenticationService {
  static Uri _loginUri = Uri.https(APIService.apiUrl, "/Identity/authenticate");
  static Future<int> login(LoginForm loginForm) async {
    var response = await http.post(_loginUri,
        body: jsonEncode(loginForm.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    return response.statusCode;
  }
}
