import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/payment.dart';
import 'api_config.dart';

class PaymentApi {
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

  Future<Payments> gets(int skip, {int? top, String? filter, String? count, String? orderBy, String? select, String? expand}) async {
    int? counter;
    List<Payment> payments = [];

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
          "${ApiConfig.odata}/${ApiConfig.paths['payment']}",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        var data = Payments.fromJson(jsonDecode(response.body));

        counter = data.count ?? 0;
        payments = data.value;
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return Payments(value: payments, count: counter);
  }

  Future<Payment> getOne(String id, String? expand) async {
    Payment payment = Payment();

    try {
      Map<String, String> query = {};

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['payment']}/$id",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        payment = Payment.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return payment;
  }

  Future<void> postOne(Payment payment) async {
    try {
      final response = await post(
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['payment']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(payment.toJson()),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> patchOne(String id, Map body) async {
    try {
      final response = await patch(
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['payment']}/$id"),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteOne(String id) async {
    try {
      final response = await delete(
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['payment']}/$id"),
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