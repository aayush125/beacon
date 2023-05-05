import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';

class AuthAPI extends BaseAPI {
  Future<http.Response> login(String phone, String password) async {
    var body = jsonEncode({'phone': phone, 'password': password});

    http.Response response = await http.post(Uri.parse(super.loginPath),
        headers: super.headers, body: body);

    return response;
  }

  Future<http.Response> logout(String token) async {
    var body = jsonEncode({'token': token});

    http.Response response = await http.post(Uri.parse(super.logoutPath),
        headers: super.headers, body: body);

    return response;
  }

  // implement a method getUser
  Future<http.Response> getRes(String token) async {
    var body = jsonEncode({'token': token});
    print(body);

    http.Response response = await http.post(Uri.parse(super.getResPath),
        headers: super.headers, body: body);
    
    print(response);

    return response;
  }

  Future<http.Response> emergencyPing(String token, bool police, bool fire, bool medical) async {
    var body = jsonEncode({'token': token, 'police': police, 'fire': fire, 'medical': medical});

    http.Response response = await http.post(Uri.parse(super.emergencyPingPath),
        headers: super.headers, body: body);

    return response;
  }
}
