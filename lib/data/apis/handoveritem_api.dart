import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/handoveritem.dart';
import 'api_config.dart';

class HandOverItemApi {
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

  Future<HandOverItems> gets(
    int skip, {
    int? top,
    String? filter,
    String? count,
    String? orderBy,
    String? select,
    String? expand,
  }) async {
    int? counter;
    List<HandOverItem> handOverItems = [];

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
          "${ApiConfig.odata}/${ApiConfig.paths['handOverItem']}",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        var data = HandOverItems.fromJson(jsonDecode(response.body));

        counter = data.count ?? 0;
        handOverItems = data.value;
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return HandOverItems(value: handOverItems, count: counter);
  }

  Future<HandOverItem> getOne(String id, String? expand) async {
    HandOverItem handOverItem = HandOverItem();

    try {
      Map<String, String> query = {};

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['handOverItem']}/$id",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        handOverItem = HandOverItem.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return handOverItem;
  }

  Future<void> postOne(HandOverItem handOverItem) async {
    try {
      final response = await post(
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['handOverItem']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(handOverItem.toJson()),
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
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['handOverItem']}/$id"),
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
        Uri.https(ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['handOverItem']}/$id"),
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
