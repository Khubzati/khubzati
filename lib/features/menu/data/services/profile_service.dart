import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';
import 'package:khubzati/core/services/app_preferences.dart';
import 'package:khubzati/features/menu/domain/models/profile_data.dart';

@injectable
class ProfileService {
  final ApiClient _apiClient = ApiClient();
  final AppPreferences _appPreferences;

  ProfileService(this._appPreferences);

  /// Fetches profile data from backend based on user role
  Future<ProfileData> getProfile() async {
    try {
      final userRole = await _appPreferences.getUserRole();
      
      // For bakery owners, fetch bakery profile
      if (userRole == 'bakery_owner') {
        return await _getBakeryProfile();
      }
      
      // For other users, fetch user profile
      return await _getUserProfile();
    } catch (e) {
      throw ApiError(message: 'Failed to load profile: ${e.toString()}');
    }
  }

  /// Fetches user profile from /users/me endpoint
  Future<ProfileData> _getUserProfile() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userProfile,
        requiresAuth: true,
      );

      // Handle response structure: { status: 'success', data: { user: {...} } }
      Map<String, dynamic> userData;
      if (response is Map) {
        if (response.containsKey('data') && response['data'] is Map) {
          final data = Map<String, dynamic>.from(response['data'] as Map);
          if (data.containsKey('user')) {
            userData = Map<String, dynamic>.from(data['user'] as Map);
          } else {
            userData = data;
          }
        } else {
          userData = Map<String, dynamic>.from(response);
        }
      } else {
        throw ApiError(message: 'Invalid response format');
      }

      // Map backend response to ProfileData
      return ProfileData(
        id: userData['id']?.toString() ?? '',
        bakeryName: userData['fullName']?.toString() ?? userData['username']?.toString() ?? '',
        address: '', // User profile doesn't have address
        phoneNumber: userData['phoneNumber']?.toString() ?? '',
        profileImageUrl: userData['profilePictureUrl']?.toString(),
        lastUpdated: userData['updatedAt'] != null
            ? DateTime.parse(userData['updatedAt'].toString())
            : null,
      );
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Failed to fetch user profile: ${e.toString()}');
    }
  }

  /// Fetches bakery profile from /bakery/profile endpoint
  Future<ProfileData> _getBakeryProfile() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.bakeryProfile,
        requiresAuth: true,
      );

      // Handle response structure: { status: 'success', data: {...} }
      Map<String, dynamic> bakeryData;
      if (response is Map) {
        if (response.containsKey('data')) {
          bakeryData = Map<String, dynamic>.from(response['data'] as Map);
        } else {
          bakeryData = Map<String, dynamic>.from(response);
        }
      } else {
        throw ApiError(message: 'Invalid response format');
      }

      // Build address from bakery address fields
      final addressParts = <String>[];
      if (bakeryData['addressLine1'] != null) {
        addressParts.add(bakeryData['addressLine1'].toString());
      }
      if (bakeryData['addressLine2'] != null) {
        addressParts.add(bakeryData['addressLine2'].toString());
      }
      if (bakeryData['city'] != null) {
        addressParts.add(bakeryData['city'].toString());
      }
      if (bakeryData['postalCode'] != null) {
        addressParts.add(bakeryData['postalCode'].toString());
      }
      final address = addressParts.join(', ');

      // Get phone number from bakery or owner
      final phoneNumber = bakeryData['phoneNumber']?.toString() ??
          bakeryData['owner']?['phoneNumber']?.toString() ??
          '';

      // Get profile image from bakery logo or owner profile picture
      final profileImageUrl = bakeryData['logoUrl']?.toString() ??
          bakeryData['owner']?['profilePictureUrl']?.toString();

      // Get username from owner (for bakery name field)
      final ownerData = bakeryData['owner'] as Map<String, dynamic>?;
      final username = ownerData?['username']?.toString() ?? 
          ownerData?['fullName']?.toString() ?? 
          '';

      // Map backend response to ProfileData
      return ProfileData(
        id: bakeryData['id']?.toString() ?? '',
        bakeryName: username, // Use owner's username for bakery name field
        address: address,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        lastUpdated: bakeryData['updatedAt'] != null
            ? DateTime.parse(bakeryData['updatedAt'].toString())
            : null,
    );
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Failed to fetch bakery profile: ${e.toString()}');
    }
  }

  /// Updates profile data based on user role
  Future<ProfileData> updateProfile({
    required String bakeryName,
    required String address,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final userRole = await _appPreferences.getUserRole();

      // For bakery owners, update bakery profile
      if (userRole == 'bakery_owner') {
        return await _updateBakeryProfile(
      bakeryName: bakeryName,
      address: address,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
        );
      }
      
      // For other users, update user profile
      return await _updateUserProfile(
        fullName: bakeryName, // For non-bakery users, bakeryName is actually fullName
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Failed to update profile: ${e.toString()}');
    }
  }

  /// Updates user profile
  Future<ProfileData> _updateUserProfile({
    required String fullName,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final data = <String, dynamic>{
        'fullName': fullName,
        'phoneNumber': phoneNumber,
      };
      
      if (profileImageUrl != null) {
        data['profilePictureUrl'] = profileImageUrl;
      }

      final response = await _apiClient.put(
        ApiConstants.updateProfile,
        data: data,
        requiresAuth: true,
      );

      // Handle response structure
      Map<String, dynamic> userData;
      if (response is Map) {
        if (response.containsKey('data') && response['data'] is Map) {
          final responseData = Map<String, dynamic>.from(response['data'] as Map);
          if (responseData.containsKey('user')) {
            userData = Map<String, dynamic>.from(responseData['user'] as Map);
          } else {
            userData = responseData;
          }
        } else {
          userData = Map<String, dynamic>.from(response);
        }
      } else {
        throw ApiError(message: 'Invalid response format');
      }

      return ProfileData(
        id: userData['id']?.toString() ?? '',
        bakeryName: userData['fullName']?.toString() ?? userData['username']?.toString() ?? '',
        address: '',
        phoneNumber: userData['phoneNumber']?.toString() ?? '',
        profileImageUrl: userData['profilePictureUrl']?.toString(),
        lastUpdated: userData['updatedAt'] != null
            ? DateTime.parse(userData['updatedAt'].toString())
            : DateTime.now(),
    );
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Failed to update user profile: ${e.toString()}');
    }
  }

  /// Updates bakery profile
  /// Note: For bakery owners, the "bakeryName" field displays the username (from owner)
  /// Username cannot be updated via the current API, so we only update bakery-specific fields
  Future<ProfileData> _updateBakeryProfile({
    required String bakeryName, // This is the username (display only, not updated)
    required String address,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      // Parse address into components (simple parsing - can be improved)
      final addressParts = address.split(',').map((e) => e.trim()).toList();
      
      // Note: Username (bakeryName field) is not updated as backend doesn't support it
      // We only update bakery-specific fields: address, phoneNumber, and logo
      
      // Update bakery profile
      final data = <String, dynamic>{
        'phoneNumber': phoneNumber,
      };
      
      if (addressParts.isNotEmpty) {
        data['addressLine1'] = addressParts[0];
        if (addressParts.length > 1) {
          data['addressLine2'] = addressParts.sublist(1).join(', ');
        }
      }
      
      if (profileImageUrl != null) {
        data['logoUrl'] = profileImageUrl;
      }

      final response = await _apiClient.put(
        ApiConstants.bakeryProfile,
        data: data,
        requiresAuth: true,
      );

      // Handle response structure
      Map<String, dynamic> bakeryData;
      if (response is Map) {
        if (response.containsKey('data')) {
          bakeryData = Map<String, dynamic>.from(response['data'] as Map);
        } else {
          bakeryData = Map<String, dynamic>.from(response);
        }
      } else {
        throw ApiError(message: 'Invalid response format');
      }

      // Build address from bakery address fields
      final addressPartsList = <String>[];
      if (bakeryData['addressLine1'] != null) {
        addressPartsList.add(bakeryData['addressLine1'].toString());
      }
      if (bakeryData['addressLine2'] != null) {
        addressPartsList.add(bakeryData['addressLine2'].toString());
      }
      if (bakeryData['city'] != null) {
        addressPartsList.add(bakeryData['city'].toString());
      }
      final fullAddress = addressPartsList.join(', ');

      // Get updated owner data for username
      final ownerData = bakeryData['owner'] as Map<String, dynamic>?;
      final username = ownerData?['username']?.toString() ?? 
          ownerData?['fullName']?.toString() ?? 
          '';

      return ProfileData(
        id: bakeryData['id']?.toString() ?? '',
        bakeryName: username, // Use owner's username
        address: fullAddress,
        phoneNumber: bakeryData['phoneNumber']?.toString() ?? '',
        profileImageUrl: bakeryData['logoUrl']?.toString(),
        lastUpdated: bakeryData['updatedAt'] != null
            ? DateTime.parse(bakeryData['updatedAt'].toString())
            : DateTime.now(),
      );
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Failed to update bakery profile: ${e.toString()}');
    }
  }

  /// Uploads profile image and returns the URL
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw ApiError(message: 'Image file not found');
      }

      final fileName = imagePath.split('/').last;
      final multipartFile = await MultipartFile.fromFile(
        imagePath,
        filename: fileName,
      );

      final response = await _apiClient.uploadFiles(
        ApiConstants.uploadDocument,
        files: [multipartFile],
        requiresAuth: true,
      );

      // Handle response structure
      String? imageUrl;
      if (response is Map) {
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is Map && data.containsKey('url')) {
            imageUrl = data['url'].toString();
          } else if (data is String) {
            imageUrl = data;
          }
        } else if (response.containsKey('url')) {
          imageUrl = response['url'].toString();
        }
      } else if (response is String) {
        imageUrl = response;
      }

      if (imageUrl == null || imageUrl.isEmpty) {
        throw ApiError(message: 'Failed to get image URL from response');
      }

      return imageUrl;
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Failed to upload profile image: ${e.toString()}');
    }
  }
}
