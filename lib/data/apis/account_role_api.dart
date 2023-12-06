import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/account_role.dart';
import 'api_config.dart';

class AccountRoleApi {
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

  Future<AccountRoles> gets(int skip,
      {int? top,
      String? filter,
      String? count,
      String? orderBy,
      String? select,
      String? expand}) async {
    int? counter;
    Set<AccountRole> accountRoles = {};

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
          "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        var data = AccountRoles.fromJson(jsonDecode(response.body));

        counter = data.count ?? 0;
        accountRoles = data.value;
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return AccountRoles(value: accountRoles, count: counter);
  }

  Future<AccountRole> getOne(String id, String? expand) async {
    AccountRole accountRole = AccountRole();

    try {
      Map<String, String> query = {};

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}/$id",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        accountRole = AccountRole.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return accountRole;
  }

  Future postOne(AccountRole accountRole) async {
    try {
      final response = await post(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(accountRole.toJson()),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<AccountRole> patchOne(String id, Map body) async {
    AccountRole accountRole = AccountRole();

    try {
      final response = await patch(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}/$id"),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      if (_isSuccessCall(response)) {
        accountRole = AccountRole.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return accountRole;
  }

  Future deleteOne(String id) async {
    try {
      final response = await delete(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}/$id"),
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
