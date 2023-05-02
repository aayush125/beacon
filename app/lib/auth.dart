import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';

class AuthAPI extends BaseAPI {
  Future<http.Response> signUp(String name, String email, String phone,
      String password, String address, String dateOfBirth, String? docType, String docID, String? blood) async {
    var body = jsonEncode(
        {'name': name, 'email': email, 'phone': phone, 'password': password, 'address': address, 'dateOfBirth': dateOfBirth, 'docType': docType, 'docID': docID, 'blood': blood});

    print(body);

    http.Response response = await http.post(Uri.parse(super.signUpPath),
        headers: super.headers, body: body);
    return response;
  }

  Future<http.Response> login(String phone, String password) async {
    var body = jsonEncode({'phone': phone, 'password': password});

    http.Response response = await http.post(Uri.parse(super.loginPath),
        headers: super.headers, body: body);

    return response;
  }

  Future<http.Response> logout(int id, String token) async {
    var body = jsonEncode({'id': id, 'token': token});

    http.Response response = await http.post(Uri.parse(super.logoutPath),
        headers: super.headers, body: body);

    return response;
  }

  // implement a method getUser
  Future<http.Response> getUserw(String token) async {
    var body = jsonEncode({'token': token});
    print(body);

    http.Response response = await http.post(Uri.parse(super.getUserPath),
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
