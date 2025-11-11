import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

@lazySingleton
class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Login with Firebase ID token (Primary method when using Firebase Auth)
  Future<Map<String, dynamic>> loginWithFirebase({
    required String idToken,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.loginWithFirebase,
        data: {
          'idToken': idToken,
        },
        requiresAuth: false,
      );

      final responseData = response['data'] ?? response;
      if (responseData['token'] != null || response['token'] != null) {
        await _saveAuthData(response);
      }

      return response;
    } catch (e) {
      ApiError error;

      if (e is DioException) {
        error = _handleAuthError(e);
      } else if (e is ApiError) {
        error = e;
      } else {
        error = _handleAuthError(e);
      }

      throw error;
    }
  }

  // Login with email/phone and OTP (two-step flow - fallback method)
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    String? otp,
  }) async {
    try {
      final data = {
        'emailOrPhone': emailOrPhone,
        if (otp != null) 'otp': otp,
      };

      final response = await _apiClient.post(
        ApiConstants.login,
        data: data,
        requiresAuth: false,
      );

      final responseData = response['data'] ?? response;
      if (responseData['token'] != null || response['token'] != null) {
        await _saveAuthData(response);
      }

      return response;
    } catch (e) {
      // Handle specific errors for bakery/restaurant owner approval
      ApiError error;

      if (e is DioException) {
        error = _handleAuthError(e);
      } else if (e is ApiError) {
        error = e;
      } else {
        error = _handleAuthError(e);
      }

      // Check if it's a 403 error with pending approval message
      if (error.statusCode == 403) {
        // Extract the specific error message from backend response
        // Backend returns: { status: 'fail', message: '...', pendingApproval: true, noVendor: false }
        dynamic errorData = error.data;
        String message = error.message;
        bool pendingApproval = false;
        bool noVendor = false;

        if (errorData != null) {
          if (errorData is Map) {
            // Direct map access
            message = errorData['message']?.toString() ?? message;
            pendingApproval = errorData['pendingApproval'] == true;
            noVendor = errorData['noVendor'] == true;
          } else if (errorData is String) {
            // Sometimes error data might be a string
            message = errorData;
          }
        }

        // Throw a more specific error with backend message
        throw ApiError(
          statusCode: 403,
          message: message,
          data: {
            'pendingApproval': pendingApproval,
            'noVendor': noVendor,
            'message': message,
          },
        );
      }

      throw error;
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
          'username': name, // Backend expects username
          'fullName': name, // Also send fullName
          'email': email,
          'phoneNumber': phone, // Backend expects phoneNumber
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
    required String
        verificationPurpose, // 'registration', 'password_reset', etc.
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
      if (verificationPurpose == 'registration' ||
          verificationPurpose == 'login') {
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
    required String
        verificationPurpose, // 'registration', 'password_reset', etc.
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

  // Upload file
  Future<Map<String, dynamic>> uploadFile({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final file = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      );

      final response = await _apiClient.uploadFiles(
        ApiConstants.uploadDocument,
        files: [file],
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Register bakery (after user registration)
  Future<Map<String, dynamic>> registerBakery({
    required String name,
    String? description,
    required String addressLine1,
    String? addressLine2,
    required String city,
    String? postalCode,
    String? country,
    required String phoneNumber,
    String? email,
    String? logoUrl,
    String? coverImageUrl,
    String? commercialRegistryUrl,
    Map<String, dynamic>? operatingHours,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.bakeryRegister,
        data: {
          'name': name,
          if (description != null) 'description': description,
          'addressLine1': addressLine1,
          if (addressLine2 != null) 'addressLine2': addressLine2,
          'city': city,
          if (postalCode != null) 'postalCode': postalCode,
          if (country != null) 'country': country,
          'phoneNumber': phoneNumber,
          if (email != null) 'email': email,
          if (logoUrl != null) 'logoUrl': logoUrl,
          if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
          if (commercialRegistryUrl != null) 'commercialRegistryUrl': commercialRegistryUrl,
          if (operatingHours != null) 'operatingHours': operatingHours,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Save authentication data
  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    if (data.containsKey('token')) {
      await _secureStorage.write(key: 'auth_token', value: data['token']);
    }

    if (data.containsKey('refreshToken')) {
      await _secureStorage.write(
          key: 'refresh_token', value: data['refreshToken']);
    }

    if (data.containsKey('user') && data['user'] is Map) {
      final user = data['user'];

      if (user.containsKey('id')) {
        await _secureStorage.write(
            key: 'user_id', value: user['id'].toString());
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
          message: 'Invalid credentials. Please check the code and try again.',
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
