import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  // Login with email/phone and password
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
    required String role, // 'customer', 'bakery_owner', 'restaurant_owner'
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'emailOrPhone': emailOrPhone,
          'password': password,
          'role': role,
        },
        requiresAuth: false,
      );
      
      // Save tokens
      await _saveAuthData(response);
      
      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  // Register new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role, // 'customer', 'bakery_owner', 'restaurant_owner'
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        },
        requiresAuth: false,
      );
      
      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String emailOrPhone,
    required String otp,
    required String verificationPurpose, // 'registration', 'password_reset', etc.
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.verifyOtp,
        data: {
          'emailOrPhone': emailOrPhone,
          'otp': otp,
          'purpose': verificationPurpose,
        },
        requiresAuth: false,
      );
      
      // If this is for registration or login, save tokens
      if (verificationPurpose == 'registration' || verificationPurpose == 'login') {
        await _saveAuthData(response);
      }
      
      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  // Resend OTP
  Future<Map<String, dynamic>> resendOtp({
    required String emailOrPhone,
    required String verificationPurpose, // 'registration', 'password_reset', etc.
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.resendOtp,
        data: {
          'emailOrPhone': emailOrPhone,
          'purpose': verificationPurpose,
        },
        requiresAuth: false,
      );
      
      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  // Forgot password - request password reset
  Future<Map<String, dynamic>> forgotPassword({
    required String emailOrPhone,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.forgotPassword,
        data: {
          'emailOrPhone': emailOrPhone,
        },
        requiresAuth: false,
      );
      
      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  // Reset password with OTP
  Future<Map<String, dynamic>> resetPassword({
    required String emailOrPhone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.resetPassword,
        data: {
          'emailOrPhone': emailOrPhone,
          'otp': otp,
          'newPassword': newPassword,
        },
        requiresAuth: false,
      );
      
      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  // Change password (when logged in)
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  // Logout
  Future<void> logout() async {
    try {
      // Call logout API
      await _apiClient.post(
        ApiConstants.logout,
        requiresAuth: true,
      );
    } catch (e) {
      // Even if API call fails, clear local tokens
      print('Logout API error: $e');
    } finally {
      // Clear stored tokens
      await _clearAuthData();
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }
  
  // Get current user role
  Future<String?> getUserRole() async {
    return await _secureStorage.read(key: 'user_role');
  }
  
  // Get user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: 'user_id');
  }
  
  // Save authentication data
  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    if (data.containsKey('token')) {
      await _secureStorage.write(key: 'auth_token', value: data['token']);
    }
    
    if (data.containsKey('refreshToken')) {
      await _secureStorage.write(key: 'refresh_token', value: data['refreshToken']);
    }
    
    if (data.containsKey('user') && data['user'] is Map) {
      final user = data['user'];
      
      if (user.containsKey('id')) {
        await _secureStorage.write(key: 'user_id', value: user['id'].toString());
      }
      
      if (user.containsKey('role')) {
        await _secureStorage.write(key: 'user_role', value: user['role']);
      }
    }
  }
  
  // Clear authentication data
  Future<void> _clearAuthData() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'refresh_token');
    await _secureStorage.delete(key: 'user_id');
    await _secureStorage.delete(key: 'user_role');
  }
  
  // Handle authentication errors
  ApiError _handleAuthError(dynamic error) {
    if (error is DioException) {
      // Handle specific auth errors
      if (error.response?.statusCode == 401) {
        return ApiError(
          statusCode: 401,
          message: 'Invalid credentials. Please check your email/phone and password.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 422) {
        return ApiError(
          statusCode: 422,
          message: 'Validation error. Please check your input.',
          data: error.response?.data,
        );
      }
    }
    
    // If it's already an ApiError, return it
    if (error is ApiError) {
      return error;
    }
    
    // Default error
    return ApiError(message: error.toString());
  }
}
