import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/core/utils/progress_dialog_utils.dart';
import 'package:drawing_on_demand/data/apiClient/api_config.dart';
import 'package:drawing_on_demand/data/models/role.dart';

class ApiRole extends GetConnect {
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

  Future<Set<Role>> gets() async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['role']}")
            .toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return Roles.fromJson(response.body).value.toSet();
      } else {
        throw response.body != null
            ? Roles.fromJson(response.body).value.toSet()
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

  Future<Role> getOne(String id) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['role']}/$id")
            .toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return Role.fromJson(response.body);
      } else {
        throw response.body != null
            ? Role.fromJson(response.body)
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

  Future<Role> postOne(Role role) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.post(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['role']}")
            .toString(),
        headers: ApiConfig.headers,
        body: role.toJson(),
      );

      if (_isSuccessCall(response)) {
        return Role.fromJson(response.body);
      } else {
        throw response.body != null
            ? Role.fromJson(response.body)
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

  Future<Role> putOne(String id, Role role) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.put(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['role']}/$id")
            .toString(),
        headers: ApiConfig.headers,
        body: role.toJson(),
      );

      if (_isSuccessCall(response)) {
        return Role.fromJson(response.body);
      } else {
        throw response.body != null
            ? Role.fromJson(response.body)
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

  Future<Role> patchOne(String id, Map body) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.patch(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['role']}/$id")
            .toString(),
        headers: ApiConfig.headers,
        body: body,
      );

      if (_isSuccessCall(response)) {
        return Role.fromJson(response.body);
      } else {
        throw response.body != null
            ? Role.fromJson(response.body)
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

  Future<Role> deleteOne(String id) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.delete(
        Uri.https(ApiConfig.baseUrl,
                "${ApiConfig.odata}/${ApiConfig.paths['role']}/$id")
            .toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return Role.fromJson(response.body);
      } else {
        throw response.body != null
            ? Role.fromJson(response.body)
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

  Future<Set<Role>> filter(String field, String value) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetworkConnected();

      Response response = await httpClient.get(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['role']}", {
          'filter': "$field eq '$value'",
        }).toString(),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        return Roles.fromJson(response.body).value.toSet();
      } else {
        throw response.body != null
            ? Roles.fromJson(response.body).value.toSet()
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
