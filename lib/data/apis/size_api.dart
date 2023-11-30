import 'dart:convert';
import 'dart:io';

import 'package:drawing_on_demand/data/apis/api_config.dart';
import 'package:drawing_on_demand/data/models/size.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class SizeApi {
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

  Future<Sizes> gets(int skip,
      {int? top,
      String? filter,
      String? count,
      String? orderBy,
      String? select,
      String? expand}) async {
    int? counter;
    Set<Size> sizes = {};

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
          "${ApiConfig.odata}/${ApiConfig.paths['size']}",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        var data = Sizes.fromJson(jsonDecode(response.body));

        counter = data.count ?? 0;
        sizes = data.value;
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return Sizes(value: sizes, count: counter);
  }

  Future<Size> getOne(String id, String? expand) async {
    Size size = Size();

    try {
      Map<String, String> query = {};

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['size']}/$id",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        size = Size.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return size;
  }

  Future postOne(Size size) async {
    try {
      final response = await post(
        Uri.https(
            ApiConfig.baseUrl, "${ApiConfig.odata}/${ApiConfig.paths['size']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(size.toJson()),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Size> patchOne(String id, Map body) async {
    Size size = Size();

    try {
      final response = await patch(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['size']}/$id"),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      if (_isSuccessCall(response)) {
        size = Size.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return size;
  }

  Future deleteOne(String id) async {
    try {
      final response = await delete(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['size']}/$id"),
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
