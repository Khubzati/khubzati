import 'package:dio/dio.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class AddressService {
  final ApiClient _apiClient = ApiClient();

  // Singleton pattern
  static final AddressService _instance = AddressService._internal();
  factory AddressService() => _instance;
  AddressService._internal();

  // Get user's addresses
  Future<List<Map<String, dynamic>>> getAddresses() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userAddresses,
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('addresses') &&
          response['addresses'] is List) {
        return List<Map<String, dynamic>>.from(response['addresses']);
      }

      return [];
    } catch (e) {
      throw _handleAddressError(e);
    }
  }

  // Add a new address
  Future<Map<String, dynamic>> addAddress({
    required String label,
    required String address,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    double? latitude,
    double? longitude,
    required bool isDefault,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.userAddresses,
        data: {
          'label': label,
          'address': address,
          'city': city,
          'state': state,
          'postal_code': postalCode,
          'country': country,
          'latitude': latitude,
          'longitude': longitude,
          'is_default': isDefault,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleAddressError(e);
    }
  }

  // Update an existing address
  Future<Map<String, dynamic>> updateAddress({
    required String addressId,
    required String label,
    required String address,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    double? latitude,
    double? longitude,
    required bool isDefault,
  }) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.userAddressDetail}$addressId',
        data: {
          'label': label,
          'address': address,
          'city': city,
          'state': state,
          'postal_code': postalCode,
          'country': country,
          'latitude': latitude,
          'longitude': longitude,
          'is_default': isDefault,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleAddressError(e);
    }
  }

  // Delete an address
  Future<void> deleteAddress(String addressId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.userAddressDetail}$addressId',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleAddressError(e);
    }
  }

  // Set default address
  Future<void> setDefaultAddress(String addressId) async {
    try {
      await _apiClient.patch(
        '${ApiConstants.userAddressDetail}$addressId/default',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleAddressError(e);
    }
  }

  // Get address by ID
  Future<Map<String, dynamic>> getAddressById(String addressId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.userAddressDetail}$addressId',
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleAddressError(e);
    }
  }

  // Search addresses (for autocomplete)
  Future<List<Map<String, dynamic>>> searchAddresses(String query) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.userAddresses}/search',
        queryParameters: {'q': query},
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('addresses') &&
          response['addresses'] is List) {
        return List<Map<String, dynamic>>.from(response['addresses']);
      }

      return [];
    } catch (e) {
      throw _handleAddressError(e);
    }
  }

  // Validate address
  Future<Map<String, dynamic>> validateAddress({
    required String address,
    required String city,
    required String state,
    required String postalCode,
    required String country,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.userAddresses}/validate',
        data: {
          'address': address,
          'city': city,
          'state': state,
          'postal_code': postalCode,
          'country': country,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleAddressError(e);
    }
  }

  // Handle address-specific errors
  ApiError _handleAddressError(dynamic error) {
    if (error is DioException) {
      // Handle specific address errors
      if (error.response?.statusCode == 400) {
        return ApiError(
          statusCode: 400,
          message: 'Invalid address information. Please check your details.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 404) {
        return ApiError(
          statusCode: 404,
          message: 'Address not found.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 422) {
        return ApiError(
          statusCode: 422,
          message: 'Address validation failed. Please check your input.',
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
