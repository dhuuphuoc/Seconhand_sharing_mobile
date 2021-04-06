import 'dart:convert';
import 'dart:io';

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

class AuthenticationService {
  static Uri _loginUri = Uri.https(APIService.apiUrl, "/Identity/authenticate");
  static Future<int> login(LoginForm loginForm) async {
    var response = await http.post(_loginUri,
        body: jsonEncode(loginForm.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    return response.statusCode;
  }
}
