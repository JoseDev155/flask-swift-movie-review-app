import 'dart:convert';

// Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/app_config.dart';
import 'services/http_service.dart';
import 'services/movie_service.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _configureDependencies() async {
  final getIt = GetIt.instance;
  final configFile = await rootBundle.loadString('assets/config/main.json');
  final configData = jsonDecode(configFile) as Map<String, dynamic>;

  final baseApiUrl = configData['BASE_API_URL'] as String?;
  final baseImageUrl = (configData['BASE_IMAGE_URL'] ??
          configData['BASE_IMAGE_API_URL'])
      as String?;
  final apiKey = configData['API_KEY'] as String?;

  if (baseApiUrl == null || baseImageUrl == null || apiKey == null) {
    throw StateError(
      'assets/config/main.json is missing required values. Expected BASE_API_URL, BASE_IMAGE_URL or BASE_IMAGE_API_URL, and API_KEY.',
    );
  }

  if (!getIt.isRegistered<AppConfig>()) {
    getIt.registerSingleton<AppConfig>(
      AppConfig(
        baseApiUrl: baseApiUrl,
        baseImageUrl: baseImageUrl,
        apiKey: apiKey,
      ),
    );
  }

  if (!getIt.isRegistered<HTTPService>()) {
    getIt.registerSingleton<HTTPService>(HTTPService());
  }

  if (!getIt.isRegistered<MovieService>()) {
    getIt.registerSingleton<MovieService>(MovieService());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flickd',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C6CFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      routerConfig: appRouter,
    );
  }
}