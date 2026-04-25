import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionStorage {
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';

  SharedPreferences? _prefs;
  String? _accessToken;
  String? _refreshToken;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs?.getString(_accessTokenKey);
    _refreshToken = _prefs?.getString(_refreshTokenKey);
  }

  bool get hasSession =>
      (_accessToken != null && _accessToken!.isNotEmpty) &&
      (_refreshToken != null && _refreshToken!.isNotEmpty);

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _prefs?.setString(_accessTokenKey, accessToken);
    await _prefs?.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clear() async {
    _prefs ??= await SharedPreferences.getInstance();
    _accessToken = null;
    _refreshToken = null;
    await _prefs?.remove(_accessTokenKey);
    await _prefs?.remove(_refreshTokenKey);
  }
}