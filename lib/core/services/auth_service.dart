import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

@lazySingleton
class AuthService {
  final FirebaseAuth firebaseAuth;
  final ApiClient _apiClient = ApiClient();

  AuthService(this.firebaseAuth);

  /// Login with email/phone and password
  Future<Map<String, dynamic>> login(
      String emailOrPhone, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'email_or_phone': emailOrPhone,
          'password': password,
        },
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Signup with user details
  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        },
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Verify OTP for signup or password reset
  Future<Map<String, dynamic>> verifyOtp(
      String verificationId, String otp) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.verifyOtp,
        data: {
          'verification_id': verificationId,
          'otp': otp,
        },
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Request OTP for password reset
  Future<Map<String, dynamic>> requestPasswordResetOtp(
      String emailOrPhone) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.forgotPassword,
        data: {
          'email_or_phone': emailOrPhone,
        },
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Reset password with OTP
  Future<bool> resetPassword({
    required String verificationId,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        ApiConstants.resetPassword,
        data: {
          'verification_id': verificationId,
          'otp': otp,
          'new_password': newPassword,
        },
      );

      return true;
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      await _apiClient.post(
        ApiConstants.logout,
        requiresAuth: true,
      );

      return true;
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }
}
