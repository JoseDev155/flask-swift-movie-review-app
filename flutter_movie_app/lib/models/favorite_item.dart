import 'movie.dart';

class FavoriteItem {
  final int id;
  final Movie movie;

  const FavoriteItem({
    required this.id,
    required this.movie,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final rawMovie = json['pelicula'];
    return FavoriteItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      movie: rawMovie is Map<String, dynamic>
          ? Movie.fromJson(rawMovie)
          : const Movie(
              id: 0,
              title: 'Untitled',
              language: 'en',
              isAdult: false,
              overview: '',
              posterPath: null,
              backdropPath: null,
              releaseDate: null,
              voteAverage: 0,
            ),
    );
  }
}