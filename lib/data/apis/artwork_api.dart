import 'dart:convert';
import 'dart:io';

import 'package:drawing_on_demand/data/apis/api_config.dart';
import 'package:drawing_on_demand/data/models/artwork.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class ArtworkApi {
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

  Future<Artworks> gets(int skip,
      {int? top,
      String? filter,
      String? count,
      String? orderBy,
      String? select,
      String? expand}) async {
    int? counter;
    Set<Artwork> artworks = {};

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
          "${ApiConfig.odata}/${ApiConfig.paths['artwork']}",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        var data = Artworks.fromJson(jsonDecode(response.body));

        counter = data.count ?? 0;
        artworks = data.value;
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return Artworks(value: artworks, count: counter);
  }

  Future<Artwork> getOne(String id, String? expand) async {
    Artwork artwork = Artwork();

    try {
      Map<String, String> query = {};

      if (expand != null) {
        query['expand'] = expand;
      }

      final response = await get(
        Uri.https(
          ApiConfig.baseUrl,
          "${ApiConfig.odata}/${ApiConfig.paths['artwork']}/$id",
          query,
        ),
        headers: ApiConfig.headers,
      );

      if (_isSuccessCall(response)) {
        artwork = Artwork.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return artwork;
  }

  Future postOne(Artwork artwork) async {
    try {
      final response = await post(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['artwork']}"),
        headers: ApiConfig.headers,
        body: jsonEncode(artwork.toJson()),
      );

      if (!_isSuccessCall(response)) {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Artwork> patchOne(String id, Map body) async {
    Artwork artwork = Artwork();

    try {
      final response = await patch(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['artwork']}/$id"),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      if (_isSuccessCall(response)) {
        artwork = Artwork.fromJson(jsonDecode(response.body));
      } else {
        throw errorSomethingWentWrong;
      }
    } catch (error) {
      rethrow;
    }

    return artwork;
  }

  Future deleteOne(String id) async {
    try {
      final response = await delete(
        Uri.https(ApiConfig.baseUrl,
            "${ApiConfig.odata}/${ApiConfig.paths['artwork']}/$id"),
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