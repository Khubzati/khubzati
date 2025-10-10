import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';
import 'package:dio/dio.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches the current user's profile information
  ///
  /// Returns detailed user profile data
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userProfile,
        requiresAuth: true,
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Updates the current user's profile information
  ///
  /// [profileData] contains the updated profile fields
  /// Returns the updated profile data
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.updateProfile,
        data: profileData,
        requiresAuth: true,
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Updates the user's profile picture
  ///
  /// [imageFile] is the new profile image file
  /// Returns the updated profile data with new image URL
  /// Throws [ApiError] if the upload fails
  Future<Map<String, dynamic>> updateProfilePicture(dynamic imageFile) async {
    try {
      final formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _apiClient.post(
        '${ApiConstants.userProfile}/picture',
        data: formData,
        requiresAuth: true,
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Changes the user's password
  ///
  /// [currentPassword] is the user's current password
  /// [newPassword] is the desired new password
  /// [confirmPassword] is the confirmation of the new password
  /// Returns success status
  /// Throws [ApiError] if the password change fails
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _apiClient.post(
        ApiConstants.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
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

  /// Updates the user's notification preferences
  ///
  /// [preferences] contains notification settings (e.g., email, push, SMS)
  /// Returns the updated notification preferences
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateNotificationPreferences(
      Map<String, dynamic> preferences) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.userProfile}/notifications',
        data: preferences,
        requiresAuth: true,
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Updates the user's language preference
  ///
  /// [languageCode] is the code of the selected language (e.g., 'ar', 'en')
  /// Returns success status
  /// Throws [ApiError] if the update fails
  Future<bool> updateLanguagePreference(String languageCode) async {
    try {
      await _apiClient.put(
        '${ApiConstants.userProfile}/language',
        data: {'language': languageCode},
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

  /// Fetches the user's saved payment methods
  ///
  /// Returns list of saved payment methods
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getSavedPaymentMethods() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.userProfile}/payment-methods',
        requiresAuth: true,
      );

      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Adds a new payment method
  ///
  /// [paymentData] contains payment method details
  /// Returns the newly added payment method
  /// Throws [ApiError] if the addition fails
  Future<Map<String, dynamic>> addPaymentMethod(
      Map<String, dynamic> paymentData) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.userProfile}/payment-methods',
        data: paymentData,
        requiresAuth: true,
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Removes a saved payment method
  ///
  /// [paymentMethodId] is the ID of the payment method to remove
  /// Returns success status
  /// Throws [ApiError] if the removal fails
  Future<bool> removePaymentMethod(String paymentMethodId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.userProfile}/payment-methods/$paymentMethodId',
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

  /// Fetches the user's delivery addresses
  ///
  /// Returns list of delivery addresses
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getDeliveryAddresses() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.userProfile}/addresses',
        requiresAuth: true,
      );

      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Adds a new delivery address
  ///
  /// [address] contains address details
  /// Returns the newly added address
  /// Throws [ApiError] if the addition fails
  Future<Map<String, dynamic>> addDeliveryAddress(
      Map<String, dynamic> address) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.userProfile}/addresses',
        data: address,
        requiresAuth: true,
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Updates an existing delivery address
  ///
  /// [addressId] is the ID of the address to update
  /// [address] contains updated address details
  /// Returns the updated address
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateDeliveryAddress(
      String addressId, Map<String, dynamic> address) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.userProfile}/addresses/$addressId',
        data: address,
        requiresAuth: true,
      );

      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Deletes a delivery address
  ///
  /// [addressId] is the ID of the address to delete
  /// Returns success status
  /// Throws [ApiError] if the deletion fails
  Future<bool> deleteDeliveryAddress(String addressId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.userProfile}/addresses/$addressId',
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
