import 'dart:convert';

import 'package:drawing_on_demand/data/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }

  Future<void> setAccount(Account account) {
    return _sharedPreferences!.setString('account', jsonEncode(account));
  }

  String getAccount() {
    try {
      return _sharedPreferences!.getString('account') ?? '';
    } catch (e) {
      return '';
    }
  }
}