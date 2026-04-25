import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/app_config.dart';
import '../models/movie.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final config = GetIt.instance.get<AppConfig>();
    final bannerUrl =
        movie.backdropUrl(config.baseImageUrl) ?? movie.posterUrl(config.baseImageUrl);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            expandedHeight: 420,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (bannerUrl != null)
                    Image.network(
                      bannerUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.black);
                      },
                    )
                  else
                    Container(color: Colors.black),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromRGBO(0, 0, 0, 0.18),
                          const Color.fromRGBO(0, 0, 0, 0.68),
                          Colors.black,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            _Chip(label: '⭐ ${movie.voteAverage.toStringAsFixed(1)}'),
                            _Chip(label: movie.language.toUpperCase()),
                            _Chip(label: movie.releaseDate ?? 'Unknown date'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Synopsis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.overview.isEmpty ? 'No overview available.' : movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.08),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.white70),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            movie.isAdult ? 'Adult content flagged.' : 'Suitable for general audiences.',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}