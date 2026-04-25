import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';
import 'auth_session_storage.dart';
import 'http_service.dart';

class AuthService {
  final GetIt getIt = GetIt.instance;

  late final HTTPService httpService;
  late final AuthSessionStorage sessionStorage;

  AuthService() {
    httpService = getIt.get<HTTPService>();
    sessionStorage = getIt.get<AuthSessionStorage>();
  }

  bool get hasSession => sessionStorage.hasSession;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await httpService.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final accessToken = data['access_token'] as String?;
      final refreshToken = data['refresh_token'] as String?;

      if (accessToken == null || refreshToken == null) {
        throw const ApiException('La respuesta de login no incluyó tokens válidos.');
      }

      await sessionStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } on DioException catch (error) {
      throw ApiException(_extractErrorMessage(error, 'No fue posible iniciar sesión.'));
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await httpService.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
    } on DioException catch (error) {
      throw ApiException(_extractErrorMessage(error, 'No fue posible registrar la cuenta.'));
    }
  }

  Future<void> logout() async {
    try {
      await httpService.post(
        '/auth/logout',
        useRefreshToken: true,
      );
    } on DioException catch (error) {
      debugPrint('Logout request failed: $error');
    } finally {
      await sessionStorage.clear();
    }
  }

  String _extractErrorMessage(DioException error, String fallback) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['error'] ?? responseData['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return fallback;
  }
}