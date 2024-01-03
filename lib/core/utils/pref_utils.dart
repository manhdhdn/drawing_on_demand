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

  /// This will clear some data stored in preference
  Future<void> clearPreferencesData() async {
    await _sharedPreferences!.remove('account');
    await _sharedPreferences!.remove('token');
    await _sharedPreferences!.remove('role');
    await _sharedPreferences!.remove('rank');
    await _sharedPreferences!.remove('cartId');
  }

  Future<bool> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (error) {
      return 'primary';
    }
  }

  Future<bool> setAccount(Account account) {
    return _sharedPreferences!.setString('account', jsonEncode(account));
  }

  String getAccount() {
    try {
      return _sharedPreferences!.getString('account')!;
    } catch (error) {
      return '{}';
    }
  }

  Future<bool> setToken(String value) {
    return _sharedPreferences!.setString('token', value);
  }

  String getToken() {
    try {
      return _sharedPreferences!.getString('token')!;
    } catch (error) {
      return '{}';
    }
  }

  Future<bool> setLanguage(String value) {
    return _sharedPreferences!.setString('language', value);
  }

  String getLanguage() {
    try {
      return _sharedPreferences!.getString('language')!;
    } catch (error) {
      return 'Vietnamese';
    }
  }

  Future<bool> setPushNotifications(bool value) {
    return _sharedPreferences!.setBool('pushNotifications', value);
  }

  bool getPushNotifications() {
    try {
      return _sharedPreferences!.getBool('pushNotifications')!;
    } catch (error) {
      return false;
    }
  }

  Future<bool> setRole(String value) {
    return _sharedPreferences!.setString('role', value);
  }

  String getRole() {
    try {
      return _sharedPreferences!.getString('role')!;
    } catch (error) {
      return 'Guest';
    }
  }

  Future<bool> setRank(String value) {
    return _sharedPreferences!.setString('rank', value);
  }

  String getRank() {
    try {
      return _sharedPreferences!.getString('rank')!;
    } catch (error) {
      return '{}';
    }
  }

  Future<bool> setCartId(String value) {
    return _sharedPreferences!.setString('cartId', value);
  }

  String getCartId() {
    try {
      return _sharedPreferences!.getString('cartId')!;
    } catch (error) {
      return '{}';
    }
  }

  Future<bool> clearCartId() async {
    return _sharedPreferences!.remove('cartId');
  }

  Future<bool> setShippingOrders(String value) {
    return _sharedPreferences!.setString('shippingOrders', value);
  }

  String getShippingOrders() {
    try {
      return _sharedPreferences!.getString('shippingOrders')!;
    } catch (error) {
      return '{}';
    }
  }

  Future<bool> clearShippingOrders() async {
    return _sharedPreferences!.remove('shippingOrders');
  }

  Future<bool> setVNPayRef(String value) {
    return _sharedPreferences!.setString('VNPayRef', value);
  }

  String getVNPayRef() {
    try {
      return _sharedPreferences!.getString('VNPayRef')!;
    } catch (error) {
      return '';
    }
  }

  Future<bool> clearVNPayRef() async {
    return _sharedPreferences!.remove('VNPayRef');
  }

  Future<bool> setDiscountId(String value) {
    return _sharedPreferences!.setString('discountId', value);
  }

  String getDiscountId() {
    try {
      return _sharedPreferences!.getString('discountId')!;
    } catch (error) {
      return '';
    }
  }

  Future<bool> clearDiscountId() async {
    return _sharedPreferences!.remove('discountId');
  }
}
