import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../models/favorite_item.dart';
import '../models/movie.dart';
import 'api_exception.dart';
import 'http_service.dart';

class FavoriteService {
  final GetIt getIt = GetIt.instance;

  late final HTTPService httpService;

  FavoriteService() {
    httpService = getIt.get<HTTPService>();
  }

  Future<List<FavoriteItem>> getFavorites() async {
    try {
      final response = await httpService.get('/favorites/');
      final data = response.data as Map<String, dynamic>;
      final favorites = data['favoritos'] as List<dynamic>? ?? const [];

      return favorites
          .whereType<Map<String, dynamic>>()
          .map(FavoriteItem.fromJson)
          .toList();
    } on DioException catch (error) {
      throw ApiException(_extractErrorMessage(error, 'No fue posible cargar favoritos.'));
    }
  }

  Future<void> addFavorite(Movie movie) async {
    try {
      await httpService.post(
        '/favorites/',
        data: {
          'api_id': movie.id,
        },
      );
    } on DioException catch (error) {
      throw ApiException(_extractErrorMessage(error, 'No fue posible añadir el favorito.'));
    }
  }

  Future<void> removeFavorite(Movie movie) async {
    try {
      await httpService.delete('/favorites/${movie.id}');
    } on DioException catch (error) {
      throw ApiException(_extractErrorMessage(error, 'No fue posible eliminar el favorito.'));
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