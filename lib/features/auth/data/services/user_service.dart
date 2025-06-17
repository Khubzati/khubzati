import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();
  
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();
  
  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userProfile,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleUserError(e);
    }
  }
  
  // Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (profileImage != null) data['profileImage'] = profileImage;
      
      final response = await _apiClient.put(
        ApiConstants.updateProfile,
        data: data,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleUserError(e);
    }
  }
  
  // Get user addresses
  Future<List<Map<String, dynamic>>> getUserAddresses() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userAddresses,
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('addresses') && response['addresses'] is List) {
        return List<Map<String, dynamic>>.from(response['addresses']);
      }
      
      return [];
    } catch (e) {
      throw _handleUserError(e);
    }
  }
  
  // Add new address
  Future<Map<String, dynamic>> addAddress({
    required String name,
    required String street,
    required String city,
    required String state,
    required String country,
    String? postalCode,
    String? instructions,
    bool isDefault = false,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.userAddresses,
        data: {
          'name': name,
          'street': street,
          'city': city,
          'state': state,
          'country': country,
          if (postalCode != null) 'postalCode': postalCode,
          if (instructions != null) 'instructions': instructions,
          'isDefault': isDefault,
        },
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleUserError(e);
    }
  }
  
  // Update address
  Future<Map<String, dynamic>> updateAddress({
    required String addressId,
    String? name,
    String? street,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? instructions,
    bool? isDefault,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (name != null) data['name'] = name;
      if (street != null) data['street'] = street;
      if (city != null) data['city'] = city;
      if (state != null) data['state'] = state;
      if (country != null) data['country'] = country;
      if (postalCode != null) data['postalCode'] = postalCode;
      if (instructions != null) data['instructions'] = instructions;
      if (isDefault != null) data['isDefault'] = isDefault;
      
      final response = await _apiClient.put(
        '${ApiConstants.userAddresses}/$addressId',
        data: data,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleUserError(e);
    }
  }
  
  // Delete address
  Future<void> deleteAddress(String addressId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.userAddresses}/$addressId',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleUserError(e);
    }
  }
  
  // Set default address
  Future<Map<String, dynamic>> setDefaultAddress(String addressId) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.userAddresses}/$addressId/default',
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleUserError(e);
    }
  }
  
  // Handle user-related errors
  ApiError _handleUserError(dynamic error) {
    // If it's already an ApiError, return it
    if (error is ApiError) {
      return error;
    }
    
    // Default error
    return ApiError(message: error.toString());
  }
}
