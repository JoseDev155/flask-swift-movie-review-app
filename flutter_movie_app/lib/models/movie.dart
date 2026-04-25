class Movie {
  final int id;
  final String title;
  final String language;
  final bool isAdult;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;

  const Movie({
    required this.id,
    required this.title,
    required this.language,
    required this.isAdult,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? (json['name'] as String?) ?? 'Untitled',
      language: (json['original_language'] as String?) ?? 'en',
      isAdult: (json['adult'] as bool?) ?? false,
      overview: (json['overview'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
    );
  }

  String? posterUrl(String baseImageUrl) {
    if (posterPath == null) {
      return null;
    }

    return '$baseImageUrl$posterPath';
  }

  String? backdropUrl(String baseImageUrl) {
    if (backdropPath == null) {
      return null;
    }

    return '$baseImageUrl$backdropPath';
  }
}
