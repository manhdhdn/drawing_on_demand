import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/core/utils/progress_dialog_utils.dart';
import 'package:drawing_on_demand/data/apiClient/api_config.dart';
import 'package:drawing_on_demand/data/models/account_role.dart';

class ApiAccountRole extends GetConnect {
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

  Future<Set<AccountRole>> gets() async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}")
            .toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return AccountRoles.fromJson(response.body).value.toSet();
      } else {
        throw response.body != null
            ? AccountRoles.fromJson(response.body).value.toSet()
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

  Future<AccountRole> getOne(String id) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}/$id")
            .toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return AccountRole.fromJson(response.body);
      } else {
        throw response.body != null
            ? AccountRole.fromJson(response.body)
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

  Future<AccountRole> postOne(AccountRole accountRole) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.post(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}")
            .toString(),
        headers: ApiConfig.headers,
        body: accountRole.toJson(),
      );

      if (_isSuccessCall(response)) {
        return AccountRole.fromJson(response.body);
      } else {
        throw response.body != null
            ? AccountRole.fromJson(response.body)
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

  Future<AccountRole> putOne(String id, AccountRole accountRole) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.put(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}/$id")
            .toString(),
        headers: ApiConfig.headers,
        body: accountRole.toJson(),
      );

      if (_isSuccessCall(response)) {
        return AccountRole.fromJson(response.body);
      } else {
        throw response.body != null
            ? AccountRole.fromJson(response.body)
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

  Future<AccountRole> patchOne(String id, Map body) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.patch(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}/$id")
            .toString(),
        headers: ApiConfig.headers,
        body: body,
      );

      if (_isSuccessCall(response)) {
        return AccountRole.fromJson(response.body);
      } else {
        throw response.body != null
            ? AccountRole.fromJson(response.body)
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

  Future<AccountRole> deleteOne(String id) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.delete(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}/$id")
            .toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return AccountRole.fromJson(response.body);
      } else {
        throw response.body != null
            ? AccountRole.fromJson(response.body)
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

  Future<Set<AccountRole>> filter(String field, String value) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['accountRole']}", {
          'filter': "$field eq '$value'",
        }).toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return AccountRoles.fromJson(response.body).value.toSet();
      } else {
        throw response.body != null
            ? AccountRoles.fromJson(response.body).value.toSet()
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
