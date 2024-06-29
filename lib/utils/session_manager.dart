import 'package:promilo_project/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final SharedPreferences _pref;
  SessionManager(this._pref);

  Future<bool> clearPref() => _pref.clear();

  String getAccessToken() => _pref.getString(Constants.prefAccessToken) ?? '';
  void setAccessToken(String value) => _pref.setString(Constants.prefAccessToken, value);

  String getUserName() => _pref.getString(Constants.prefUserName) ?? '';
  void setUserName(String value) => _pref.setString(Constants.prefUserName, value);

  String getPassword() => _pref.getString(Constants.prefPassword) ?? '';
  void setPassword(String value) => _pref.setString(Constants.prefPassword, value);

  bool isRemember() => _pref.getBool(Constants.prefIsRemember) ?? false;
  void setRemember(bool value) => _pref.setBool(Constants.prefIsRemember, value);

}
