import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/vnpay_request.dart';
import 'api_config.dart';

class VNPayApi {
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

  Future<VNPayRequest> postOne(VNPayRequest request) async {
    try {
      final response = await post(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['vnpay']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(request.toJson()),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      } else {
        return VNPayRequest.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      rethrow;
    }
  }
}
