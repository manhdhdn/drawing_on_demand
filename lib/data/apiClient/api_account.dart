import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/core/utils/progress_dialog_utils.dart';
import 'package:drawing_on_demand/data/apiClient/api_config.dart';
import 'package:drawing_on_demand/data/models/account.dart';

class ApiAccount extends GetConnect {
  @override
  void onInit() {
    super.onInit();

    httpClient.timeout = const Duration(seconds: 60);
  }

  Future isNetworkConnected() async {
    if (!await Get.find<NetworkInfo>().isConnected()) {
      throw NoInternetException('No Internet Found!');
    }
  }

  bool _isSuccessCall(Response response) {
    return response.isOk;
  }

  Future<Set<Account>> gets() async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        "${ApiConfig.baseUrl}/${ApiConfig.paths['account']}",
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return Accounts.fromJson(response.body).value.toSet();
      } else {
        throw response.body != null
            ? Accounts.fromJson(response.body).value.toSet()
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  Future<Account> getOne(String id) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        "${ApiConfig.baseUrl}/${ApiConfig.paths['account']}/$id",
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return Account.fromJson(response.body);
      } else {
        throw response.body != null
            ? Account.fromJson(response.body)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  Future<Account> postOne(Account account) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Map accountMap = account.toJson();

      Response response = await httpClient.post(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['account']}")
            .toString(),
        headers: ApiConfig.headers,
        body: account.toJson(),
      );

      if (_isSuccessCall(response)) {
        return Account.fromJson(response.body);
      } else {
        throw response.body != null
            ? Account.fromJson(response.body)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  Future<Account> putOne(String id, Account account) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.put(
        "${ApiConfig.baseUrl}/${ApiConfig.paths['account']}/$id",
        headers: ApiConfig.headers,
        body: account.toJson(),
      );

      if (_isSuccessCall(response)) {
        return Account.fromJson(response.body);
      } else {
        throw response.body != null
            ? Account.fromJson(response.body)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  Future<Account> patchOne(String id, Map body) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.patch(
        "${ApiConfig.baseUrl}/${ApiConfig.paths['account']}/$id",
        headers: ApiConfig.headers,
        body: body,
      );

      if (_isSuccessCall(response)) {
        return Account.fromJson(response.body);
      } else {
        throw response.body != null
            ? Account.fromJson(response.body)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  Future<Account> deleteOne(String id) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.delete(
        "${ApiConfig.baseUrl}/${ApiConfig.paths['account']}/$id",
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return Account.fromJson(response.body);
      } else {
        throw response.body != null
            ? Account.fromJson(response.body)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  Future<Set<Account>> filter(String field, String value) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['account']}", {
          'filter': "$field eq '$value'",
        }).toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return Accounts.fromJson(response.body).value.toSet();
      } else {
        throw response.body != null
            ? Accounts.fromJson(response.body).value.toSet()
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }
}
