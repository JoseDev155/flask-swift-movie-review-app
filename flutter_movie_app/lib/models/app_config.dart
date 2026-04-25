class AppConfig {
  final String baseApiUrl;
  final String baseImageUrl;
  final String? apiKey;

  const AppConfig({
    required this.baseApiUrl,
    required this.baseImageUrl,
    this.apiKey,
  });
}