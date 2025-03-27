import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppEnv {
  static String get baseUrl => _get('BASE_URL');

  static String _get(String key) => dotenv.get(key, fallback: '');
}
