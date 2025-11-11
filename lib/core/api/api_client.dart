// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';
import 'package:khubzati/core/api/interceptors/auth_interceptor.dart';
import 'package:khubzati/core/api/interceptors/logging_interceptor.dart';

class ApiClient {
  late Dio _dio;
  final secure_storage.FlutterSecureStorage _secureStorage =
      const secure_storage.FlutterSecureStorage();

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _initDio();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout:
          const Duration(milliseconds: ApiConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor(_secureStorage));

    if (kDebugMode) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }

  // Generic GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: requiresAuth ? await _getAuthHeader() : null,
            ),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // Generic POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: requiresAuth ? await _getAuthHeader() : null,
            ),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // Generic PUT request
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: requiresAuth ? await _getAuthHeader() : null,
            ),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // Generic PATCH request
  Future<dynamic> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: requiresAuth ? await _getAuthHeader() : null,
            ),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // Generic DELETE request
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: requiresAuth ? await _getAuthHeader() : null,
            ),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // Upload file(s)
  Future<dynamic> uploadFiles(
    String endpoint, {
    required List<MultipartFile> files,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final formData = FormData();

      // Add files
      // For single file upload, use 'file', for multiple use 'file0', 'file1', etc.
      if (files.length == 1) {
        formData.files.add(MapEntry('file', files[0]));
      } else {
        for (var i = 0; i < files.length; i++) {
          formData.files.add(MapEntry('file$i', files[i]));
        }
      }

      // Add other data
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      final response = await _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: requiresAuth ? await _getAuthHeader() : null,
            ),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // Process API response
  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return response.data;
      case 400:
        throw ApiError(
          statusCode: response.statusCode,
          message: 'Bad request',
          data: response.data,
        );
      case 401:
        throw ApiError(
          statusCode: response.statusCode,
          message: 'Unauthorized',
          data: response.data,
        );
      case 403:
        throw ApiError(
          statusCode: response.statusCode,
          message: 'Forbidden',
          data: response.data,
        );
      case 404:
        throw ApiError(
          statusCode: response.statusCode,
          message: 'Not found',
          data: response.data,
        );
      case 422:
        throw ApiError(
          statusCode: response.statusCode,
          message: 'Validation error',
          data: response.data,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        throw ApiError(
          statusCode: response.statusCode,
          message: 'Server error',
          data: response.data,
        );
      default:
        throw ApiError(
          statusCode: response.statusCode,
          message: 'Unknown error occurred',
          data: response.data,
        );
    }
  }

  // Handle Dio errors
  ApiError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        return ApiError(
          statusCode: error.response?.statusCode,
          message: error.response?.statusMessage ?? 'Bad response',
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiError(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return ApiError(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
        );
      default:
        return ApiError(message: error.message ?? 'Unknown error occurred');
    }
  }

  // Get auth header
  Future<Map<String, dynamic>> _getAuthHeader() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return {
      'Authorization': 'Bearer $token',
    };
  }
}
