import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/favorite_item.dart';
import '../services/api_exception.dart';
import '../services/favorite_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoriteService _favoriteService = GetIt.instance.get<FavoriteService>();

  bool _isLoading = true;
  String? _errorMessage;
  List<FavoriteItem> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final favorites = await _favoriteService.getFavorites();
      if (!mounted) {
        return;
      }

      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(FavoriteItem item) async {
    try {
      await _favoriteService.removeFavorite(item.movie);
      if (!mounted) {
        return;
      }

      setState(() {
        _favorites.removeWhere((favorite) => favorite.id == item.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favorito eliminado')),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Mis favoritos'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadFavorites,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _errorMessage != null
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  )
                : _favorites.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 120),
                          const Center(
                            child: Text(
                              'Todavía no tienes favoritos.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: FilledButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF8C7CFF),
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.explore_outlined),
                              label: const Text('Explorar películas'),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _favorites.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = _favorites[index];
                          return _FavoriteCard(
                            favorite: item,
                            onRemove: () => _removeFavorite(item),
                          );
                        },
                      ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.favorite, required this.onRemove});

  final FavoriteItem favorite;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.04),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: favorite.movie.posterPath == null
                  ? Container(
                      width: 84,
                      height: 124,
                      color: const Color.fromRGBO(255, 255, 255, 0.06),
                      child: const Icon(Icons.movie_outlined, color: Colors.white54),
                    )
                  : Image.network(
                      favorite.movie.posterUrl('https://image.tmdb.org/t/p/original/')!,
                      width: 84,
                      height: 124,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 84,
                          height: 124,
                          color: const Color.fromRGBO(255, 255, 255, 0.06),
                          child: const Icon(Icons.broken_image_outlined, color: Colors.white54),
                        );
                      },
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorite.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    favorite.movie.overview.isEmpty
                        ? 'Sin sinopsis disponible.'
                        : favorite.movie.overview,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, height: 1.35),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Quitar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}