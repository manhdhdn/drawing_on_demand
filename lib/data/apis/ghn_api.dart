import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/ghn_request.dart';
import 'api_config.dart';

class GHNApi {
  Future<void> isNetworkConnected() async {
    try {
      if (!isWeb) {
        await InternetAddress.lookup('google.com');
      }
    } catch (error) {
      throw errorInternetNotAvailable;
    }
  }

  bool _isSuccessCall(Response response) {
    return response.statusCode >= 200 && response.statusCode < 400;
  }

  Future<GHNRequest> postOne(GHNRequest request) async {
    try {
      final response = await post(
        Uri.https(
            ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['ghn']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(request.toJson()),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      } else {
        return GHNRequest.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      rethrow;
    }
  }
}
