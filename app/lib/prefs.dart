import 'package:shared_preferences/shared_preferences.dart';

void upDateSharedPreferences(String token) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString('token', token);
}
