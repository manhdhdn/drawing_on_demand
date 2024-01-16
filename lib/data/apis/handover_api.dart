import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/handover.dart';
import 'api_config.dart';

class HandOverApi {
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

  Future<HandOvers> gets(int skip, {int? top, String? filter, String? count, String? orderBy, String? select, String? expand}) async {
    int? counter;
    List<HandOver> handOvers = [];

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
          "${ApiConfig.odata}/${ApiConfig.paths['handOver']}",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        var data = HandOvers.fromJson(jsonDecode(response.body));

        counter = data.count ?? 0;
        handOvers = data.value;
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return HandOvers(value: handOvers, count: counter);
  }

  Future<HandOver> getOne(String id, String? expand) async {
    HandOver handOver = HandOver();

    try {
      Map<String, String> query = {};

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['handOver']}/$id",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        handOver = HandOver.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return handOver;
  }

  Future<void> postOne(HandOver handOver) async {
    try {
      final response = await post(
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['handOver']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(handOver.toJson()),
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
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['handOver']}/$id"),
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
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['handOver']}/$id"),
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
