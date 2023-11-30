import 'dart:convert';
import 'dart:io';

import 'package:drawing_on_demand/data/apis/api_config.dart';
import 'package:drawing_on_demand/data/models/account.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class AccountApi {
  Future<void> isNetworkConnected() async {
    try {
      if (!isWeb) {
        await InternetAddress.lookup(ApiConfig.baseUrl);
      }
    } catch (error) {
      throw errorInternetNotAvailable;
    }
  }

  bool _isSuccessCall(Response response) {
    return response.statusCode >= 200 && response.statusCode < 400;
  }

  Future<Accounts> gets(int skip,
      {int? top,
      String? filter,
      String? count,
      String? orderBy,
      String? select,
      String? expand}) async {
    int? counter;
    Set<Account> accounts = {};

    try {
      await isNetworkConnected();

      Map<String, String> query = {
        'skip': '$skip',
      };

      if (top != null) {
        query['top'] = '$top';
      }

      if (filter != null) {
        query['filter'] = filter;
      }

      if (count != null) {
        query['count'] = count;
      }

      if (orderBy != null) {
        query['orderby'] = orderBy;
      }

      if (select != null) {
        query['select'] = select;
      }

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['account']}",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        var data = Accounts.fromJson(jsonDecode(response.body));

        counter = data.count ?? 0;
        accounts = data.value;
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return Accounts(value: accounts, count: counter);
  }

  Future<Account> getOne(String id, String? expand) async {
    Account account = Account();

    try {
      Map<String, String> query = {};

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['account']}/$id",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        account = Account.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return account;
  }

  Future postOne(Account account) async {
    try {
      final response = await post(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['account']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(account.toJson()),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Account> patchOne(String id, Map body) async {
    Account account = Account();

    try {
      final response = await patch(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['account']}/$id"),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      if (_isSuccessCall(response)) {
        account = Account.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return account;
  }

  Future deleteOne(String id) async {
    try {
      final response = await delete(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['account']}/$id"),
        headers: ApiConfig.headers,
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }
  }
}