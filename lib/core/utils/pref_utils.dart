import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/account.dart';

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
    _sharedPreferences!.remove('account');
    _sharedPreferences!.remove('role');
    _sharedPreferences!.remove('rank');
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
      return _sharedPreferences!.getString('account')!;
    } catch (e) {
      return '';
    }
  }

  Future<void> setLanguage(String value) {
    return _sharedPreferences!.setString('language', value);
  }

  String getLanguage() {
    try {
      return _sharedPreferences!.getString('language')!;
    } catch (e) {
      return 'Vietnamese';
    }
  }

  Future<void> setPushNotifications(bool value) {
    return _sharedPreferences!.setBool('pushNotifications', value);
  }

  bool getPushNotifications() {
    try {
      return _sharedPreferences!.getBool('pushNotifications')!;
    } catch (e) {
      return false;
    }
  }

  Future<void> setRole(String value) {
    return _sharedPreferences!.setString('role', value);
  }

  String getRole() {
    try {
      return _sharedPreferences!.getString('role')!;
    } catch (e) {
      return 'Guest';
    }
  }

  Future<void> setRank(String value) {
    return _sharedPreferences!.setString('rank', value);
  }

  String getRank() {
    try {
      return _sharedPreferences!.getString('rank')!;
    } catch (e) {
      return '';
    }
  }
      
  Future<void> setTermId(String value) {
    return _sharedPreferences!.setString('termId', value);
  }

  String getTermId() {
    try {
      return _sharedPreferences!.getString('termId')!;
    } catch (e) {
      return '';
    }
  }

  void clearTermId() {
    _sharedPreferences!.remove('termId');
  }
}
