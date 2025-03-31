import 'package:dio/dio.dart';

import '../utils/constants/env.dart';
import '../utils/errors/base_error.dart';
import 'i_http_connect_interface.dart';

class DioHttpConnect implements IHttpConnect {
  final Dio _dio = Dio();
  final List<Interceptor> lstInterceptor;
  final Duration? connectTimeout;
  final Duration? receiveTimeout;

  DioHttpConnect({
    this.lstInterceptor = const [],
    this.connectTimeout,
    this.receiveTimeout,
  }) {
    _dio.httpClientAdapter = HttpClientAdapter();
    _dio.options = BaseOptions(
      baseUrl: AppEnv.baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      contentType: Headers.jsonContentType,
    );

    for (var interceptor in lstInterceptor) {
      _dio.interceptors.add(interceptor);
    }
  }

  @override
  Future<bool> checkConnectivity() async {
    try {
      final response = await _dio.get('https://www.google.com');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (error) {
      if (error.error != null) throw error.error!;
      rethrow;
    } catch (error, stacktrace) {
      throw UnknownError(
        stackTrace: stacktrace,
        errorMessage: error.toString(),
      );
    }
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (error) {
      if (error.error != null) throw error.error!;
      rethrow;
    } catch (error, stacktrace) {
      throw UnknownError(
        stackTrace: stacktrace,
        errorMessage: error.toString(),
      );
    }
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (error) {
      if (error.error != null) throw error.error!;
      rethrow;
    } catch (error, stacktrace) {
      throw UnknownError(
        stackTrace: stacktrace,
        errorMessage: error.toString(),
      );
    }
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (error) {
      if (error.error != null) throw error.error!;
      rethrow;
    } catch (error, stacktrace) {
      throw UnknownError(
        stackTrace: stacktrace,
        errorMessage: error.toString(),
      );
    }
  }

  @override
  Future<Response<dynamic>> fetch(requestOptions) async {
    try {
      var response = await _dio.fetch(requestOptions);

      return response;
    } on DioException catch (error) {
      if (error.error != null) throw error.error!;
      rethrow;
    } catch (error, stacktrace) {
      throw UnknownError(
        stackTrace: stacktrace,
        errorMessage: error.toString(),
      );
    }
  }
}
