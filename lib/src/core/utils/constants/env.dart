import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppEnv {
  static String _getString(String key) => dotenv.get(key, fallback: '');
  static int _getInt(String key) => dotenv.getInt(key, fallback: 0);

  static String get baseUrl => _getString('BASE_URL');
  static int get companiesCacheTtlMinutes =>
      _getInt('COMPANIES_CACHE_TTL_MINUTES');
  static int get assetsCacheTtlMinutes => _getInt('ASSETS_CACHE_TTL_MINUTES');
  static int get locationsCacheTtlMinutes =>
      _getInt('LOCATIONS_CACHE_TTL_MINUTES');
}
