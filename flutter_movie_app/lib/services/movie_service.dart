// Packages
import 'package:get_it/get_it.dart';

// Services
import '../services/http_service.dart';
import '../models/movie_page.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  late final HTTPService httpService;

  MovieService() {
    httpService = getIt.get<HTTPService>();
  }

  Future<MoviePage> getPopularMovies({int page = 1}) async {
    return _getMovies('/movies/popular', query: {'page': page});
  }

  Future<MoviePage> getUpcomingMovies({int page = 1}) async {
    return _getMovies('/movies/upcoming', query: {'page': page});
  }

  Future<MoviePage> searchMovies(String searchTerm, {int page = 1}) async {
    return _getMovies(
      '/movies/search',
      query: {
        'query': searchTerm,
        'page': page,
      },
    );
  }

  Future<MoviePage> _getMovies(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final response = await httpService.get(path, query: query);
    final data = response.data as Map<String, dynamic>;

    return MoviePage.fromJson(data);
  }
}