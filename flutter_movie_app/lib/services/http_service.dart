import '../models/app_config.dart';

// Packages
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late final String baseUrl;
  late final String apiKey;

  HTTPService() {
    final config = getIt.get<AppConfig>();
    baseUrl = config.baseApiUrl;
    apiKey = config.apiKey;
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final url = '$baseUrl$path';
      final requestQuery = <String, dynamic>{
        'api_key': apiKey,
        'language': 'en-US',
      };

      if (query != null) {
        requestQuery.addAll(query);
      }
      return await dio.get(url, queryParameters: requestQuery);
    } on DioException catch (e) {
      debugPrint('Unable to perform get request.');
      debugPrint('DioException: $e');
      rethrow;
    }
  }
}