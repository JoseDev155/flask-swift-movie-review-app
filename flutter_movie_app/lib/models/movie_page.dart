import 'movie.dart';

class MoviePage {
  final List<Movie> movies;
  final int currentPage;
  final int totalPages;

  const MoviePage({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
  });

  factory MoviePage.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List<dynamic>? ?? const [];

    return MoviePage(
      movies: results
          .map((movie) => Movie.fromJson(movie as Map<String, dynamic>))
          .toList(),
      currentPage: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }

  bool get hasMore => currentPage < totalPages;
}