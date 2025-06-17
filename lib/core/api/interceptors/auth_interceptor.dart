import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khubzati/core/api/api_constants.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  
  AuthInterceptor(this._secureStorage);
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for login, register, etc.
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }
    
    final token = await _secureStorage.read(key: 'auth_token');
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }
  
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized errors (token expired)
    if (err.response?.statusCode == 401) {
      // Try to refresh the token
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      
      if (refreshToken != null) {
        try {
          // Create a new Dio instance to avoid interceptor loops
          final dio = Dio();
          
          final response = await dio.post(
            '${ApiConstants.baseUrl}${ApiConstants.refreshToken}',
            data: {'refresh_token': refreshToken},
          );
          
          if (response.statusCode == 200) {
            final newToken = response.data['token'];
            final newRefreshToken = response.data['refresh_token'];
            
            // Save new tokens
            await _secureStorage.write(key: 'auth_token', value: newToken);
            await _secureStorage.write(key: 'refresh_token', value: newRefreshToken);
            
            // Retry the original request with the new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';
            
            final newResponse = await dio.fetch(options);
            return handler.resolve(newResponse);
          }
        } catch (e) {
          // If refresh token fails, clear tokens and let the error propagate
          await _secureStorage.delete(key: 'auth_token');
          await _secureStorage.delete(key: 'refresh_token');
        }
      }
    }
    
    return handler.next(err);
  }
  
  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      ApiConstants.login,
      ApiConstants.register,
      ApiConstants.verifyOtp,
      ApiConstants.resendOtp,
      ApiConstants.forgotPassword,
      ApiConstants.resetPassword,
      ApiConstants.refreshToken,
    ];
    
    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
