// Packages
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../models/app_config.dart';
import '../models/movie.dart';
import '../models/movie_page.dart';
import '../services/auth_service.dart';
import '../services/movie_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<String> _categories = ['Popular', 'Upcoming'];

  final MovieService _movieService = GetIt.instance.get<MovieService>();
  final AuthService _authService = GetIt.instance.get<AuthService>();
  final AppConfig _config = GetIt.instance.get<AppConfig>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;
  List<Movie> _movies = [];
  Movie? _selectedMovie;
  String _selectedCategory = 'Popular';
  String _searchText = '';
  int _nextPage = 1;
  bool _hasMoreMovies = true;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMovies(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _isInitialLoading ||
        _isLoadingMore ||
        !_hasMoreMovies) {
      return;
    }

    if (_scrollController.position.extentAfter < 320) {
      _loadMovies();
    }
  }

  Future<void> _loadMovies({bool reset = false}) async {
    if (reset) {
      _nextPage = 1;
      _hasMoreMovies = true;

      if (mounted) {
        setState(() {
          _movies = [];
          _selectedMovie = null;
          _errorMessage = null;
          _isInitialLoading = true;
          _isLoadingMore = false;
        });
      }
    } else {
      if (_isInitialLoading || _isLoadingMore || !_hasMoreMovies) {
        return;
      }

      if (mounted) {
        setState(() {
          _isLoadingMore = true;
        });
      }
    }

    final activeQuery = _searchText.trim();
    final activeCategory = _selectedCategory;
    final page = _nextPage;

    try {
      final MoviePage moviePage;

      if (activeQuery.isNotEmpty) {
        moviePage = await _movieService.searchMovies(activeQuery, page: page);
      } else if (activeCategory == 'Upcoming') {
        moviePage = await _movieService.getUpcomingMovies(page: page);
      } else {
        moviePage = await _movieService.getPopularMovies(page: page);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        if (reset) {
          _movies = moviePage.movies;
          _selectedMovie = _movies.isNotEmpty ? _movies.first : null;
        } else {
          _movies = [..._movies, ...moviePage.movies];
        }

        _nextPage = moviePage.currentPage + 1;
        _hasMoreMovies = moviePage.hasMore;
        _isInitialLoading = false;
        _isLoadingMore = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        if (reset) {
          _movies = [];
          _selectedMovie = null;
        }
        _isInitialLoading = false;
        _isLoadingMore = false;
        _errorMessage = 'No se pudieron cargar las películas.';
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _searchText = value;
    });

    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) {
        return;
      }

      _loadMovies(reset: true);
    });
  }

  void _onCategoryChanged(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }

    setState(() {
      _selectedCategory = value;
      _searchText = '';
      _searchController.clear();
    });

    _loadMovies(reset: true);
  }

  void _selectMovie(Movie movie) {
    setState(() {
      _selectedMovie = movie;
    });
  }

  void _openMovieDetails(Movie movie) {
    context.push('/movie', extra: movie);
  }

  void _openFavorites() {
    context.push('/favorites');
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) {
      return;
    }

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          _buildOverlay(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    final movie = _selectedMovie;
    final imageUrl = movie?.backdropUrl(_config.baseImageUrl) ??
        movie?.posterUrl(_config.baseImageUrl);

    if (imageUrl == null) {
      return Container(color: Colors.black);
    }

    return Positioned.fill(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: Colors.black);
          },
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromRGBO(0, 0, 0, 0.52),
              const Color.fromRGBO(0, 0, 0, 0.64),
              const Color.fromRGBO(0, 0, 0, 0.88),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.45),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.white38),
                hintText: 'Search....',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _openFavorites,
            icon: const Icon(Icons.favorite_border, color: Colors.white70),
            tooltip: 'Favorites',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                onChanged: _onCategoryChanged,
                dropdownColor: const Color(0xFF101014),
                icon: const Icon(Icons.menu, color: Colors.white54),
                style: const TextStyle(color: Colors.white),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    if (_movies.isEmpty) {
      return const Center(
        child: Text(
          'No hay películas para mostrar.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: _movies.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _movies.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final movie = _movies[index];
        final posterUrl = movie.posterUrl(_config.baseImageUrl);

        return _MovieTile(
          movie: movie,
          posterUrl: posterUrl,
          isSelected: _selectedMovie?.id == movie.id,
          onTap: () => _selectMovie(movie),
          onDetails: () => _openMovieDetails(movie),
        );
      },
    );
  }
}

class _MovieTile extends StatelessWidget {
  const _MovieTile({
    required this.movie,
    required this.posterUrl,
    required this.isSelected,
    required this.onTap,
    required this.onDetails,
  });

  final Movie movie;
  final String? posterUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
      onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, isSelected ? 0.42 : 0.34),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected
                    ? const Color.fromRGBO(255, 255, 255, 0.22)
                    : const Color.fromRGBO(255, 255, 255, 0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Poster(posterUrl: posterUrl),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                height: 1.05,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${movie.language.toUpperCase()} | R: ${movie.isAdult} | ${movie.releaseDate ?? 'Unknown'}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.overview,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: onDetails,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(Icons.chevron_right, size: 18),
                          label: const Text('View details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.posterUrl});

  final String? posterUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 96,
        height: 144,
        color: const Color.fromRGBO(255, 255, 255, 0.06),
        child: posterUrl == null
            ? const Icon(Icons.movie_outlined, color: Colors.white54, size: 40)
            : Image.network(
                posterUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white54,
                    size: 40,
                  );
                },
              ),
      ),
    );
  }
}