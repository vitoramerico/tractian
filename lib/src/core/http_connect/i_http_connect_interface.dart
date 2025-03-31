abstract interface class IHttpConnect {
  Future<bool> checkConnectivity();

  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> fetch(dynamic requestOptions);
}
