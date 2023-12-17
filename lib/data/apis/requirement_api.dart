import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/requirement.dart';
import 'api_config.dart';

class RequirementApi {
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

  Future<Requirements> gets(int skip,
      {int? top,
      String? filter,
      String? count,
      String? orderBy,
      String? select,
      String? expand}) async {
    int? counter;
    List<Requirement> requirements = [];

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
          "${ApiConfig.odata}/${ApiConfig.paths['requirement']}",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        var data = Requirements.fromJson(jsonDecode(response.body));

        counter = data.count ?? 0;
        requirements = data.value;
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return Requirements(value: requirements, count: counter);
  }

  Future<Requirement> getOne(String id, String? expand) async {
    Requirement requirement = Requirement();

    try {
      Map<String, String> query = {};

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['requirement']}/$id",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        requirement = Requirement.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return requirement;
  }

  Future<void> postOne(Requirement requirement) async {
    try {
      final response = await post(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['requirement']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(requirement.toJson()),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Requirement> patchOne(String id, Map body) async {
    Requirement requirement = Requirement();

    try {
      final response = await patch(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['requirement']}/$id"),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      if (_isSuccessCall(response)) {
        requirement = Requirement.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return requirement;
  }

  Future<void> deleteOne(String id) async {
    try {
      final response = await delete(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['requirement']}/$id"),
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
