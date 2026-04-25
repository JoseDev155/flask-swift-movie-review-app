import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/movie.dart';
import 'pages/movie_detail_page.dart';
import 'pages/splash_page.dart';
import 'pages/main_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/movie',
      name: 'movie-detail',
      builder: (context, state) {
        final movie = state.extra;
        if (movie is! Movie) {
          return const Scaffold(
            body: Center(
              child: Text('Movie details are unavailable.'),
            ),
          );
        }

        return MovieDetailPage(movie: movie);
      },
    ),
  ],
);
