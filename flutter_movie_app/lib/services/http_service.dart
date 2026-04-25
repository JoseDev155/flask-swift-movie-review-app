import '../models/app_config.dart';
import 'auth_session_storage.dart';

// Packages
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late final String baseUrl;
  late final String? apiKey;
  late final AuthSessionStorage sessionStorage;

  HTTPService() {
    final config = getIt.get<AppConfig>();
    baseUrl = config.baseApiUrl;
    apiKey = config.apiKey;
    sessionStorage = getIt.get<AuthSessionStorage>();
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final url = '$baseUrl$path';
      final requestQuery = <String, dynamic>{
        'language': 'en-US',
      };

      if (apiKey != null && apiKey!.isNotEmpty) {
        requestQuery['api_key'] = apiKey;
      }

      if (query != null) {
        requestQuery.addAll(query);
      }
      return await dio.get(
        url,
        queryParameters: requestQuery,
        options: _options(),
      );
    } on DioException catch (e) {
      debugPrint('Unable to perform get request.');
      debugPrint('DioException: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool useRefreshToken = false,
  }) async {
    try {
      final url = '$baseUrl$path';
      return await dio.post(
        url,
        data: data,
        queryParameters: query,
        options: _options(useRefreshToken: useRefreshToken),
      );
    } on DioException catch (e) {
      debugPrint('Unable to perform post request.');
      debugPrint('DioException: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool useRefreshToken = false,
  }) async {
    try {
      final url = '$baseUrl$path';
      return await dio.put(
        url,
        data: data,
        queryParameters: query,
        options: _options(useRefreshToken: useRefreshToken),
      );
    } on DioException catch (e) {
      debugPrint('Unable to perform put request.');
      debugPrint('DioException: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool useRefreshToken = false,
  }) async {
    try {
      final url = '$baseUrl$path';
      return await dio.delete(
        url,
        data: data,
        queryParameters: query,
        options: _options(useRefreshToken: useRefreshToken),
      );
    } on DioException catch (e) {
      debugPrint('Unable to perform delete request.');
      debugPrint('DioException: $e');
      rethrow;
    }
  }

  Options _options({bool useRefreshToken = false}) {
    final token = useRefreshToken
        ? sessionStorage.refreshToken
        : sessionStorage.accessToken;

    final headers = <String, dynamic>{
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    return Options(headers: headers);
  }
}