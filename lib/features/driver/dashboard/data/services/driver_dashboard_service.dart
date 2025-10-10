import 'package:dio/dio.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_error.dart';

class DriverDashboardService {
  final ApiClient _apiClient = ApiClient();

  // Singleton pattern
  static final DriverDashboardService _instance =
      DriverDashboardService._internal();
  factory DriverDashboardService() => _instance;
  DriverDashboardService._internal();

  // Get driver dashboard data
  Future<Map<String, dynamic>> getDriverDashboard() async {
    try {
      final response = await _apiClient.get(
        '/driver/dashboard',
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleDriverError(e);
    }
  }

  // Update driver online/offline status
  Future<Map<String, dynamic>> updateDriverStatus(bool isOnline) async {
    try {
      final response = await _apiClient.patch(
        '/driver/status',
        data: {'is_online': isOnline},
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleDriverError(e);
    }
  }

  // Accept a delivery
  Future<Map<String, dynamic>> acceptDelivery(String deliveryId) async {
    try {
      final response = await _apiClient.post(
        '/driver/deliveries/$deliveryId/accept',
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleDriverError(e);
    }
  }

  // Update delivery status
  Future<Map<String, dynamic>> updateDeliveryStatus(
      String deliveryId, String status) async {
    try {
      final response = await _apiClient.patch(
        '/driver/deliveries/$deliveryId/status',
        data: {'status': status},
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleDriverError(e);
    }
  }

  // Update driver location
  Future<Map<String, dynamic>> updateDriverLocation(
      double latitude, double longitude) async {
    try {
      final response = await _apiClient.post(
        '/driver/location',
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleDriverError(e);
    }
  }

  // Get available deliveries
  Future<List<Map<String, dynamic>>> getAvailableDeliveries() async {
    try {
      final response = await _apiClient.get(
        '/driver/deliveries/available',
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('deliveries') &&
          response['deliveries'] is List) {
        return List<Map<String, dynamic>>.from(response['deliveries']);
      }

      return [];
    } catch (e) {
      throw _handleDriverError(e);
    }
  }

  // Get driver's active deliveries
  Future<List<Map<String, dynamic>>> getActiveDeliveries() async {
    try {
      final response = await _apiClient.get(
        '/driver/deliveries/active',
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('deliveries') &&
          response['deliveries'] is List) {
        return List<Map<String, dynamic>>.from(response['deliveries']);
      }

      return [];
    } catch (e) {
      throw _handleDriverError(e);
    }
  }

  // Get driver's completed deliveries
  Future<List<Map<String, dynamic>>> getCompletedDeliveries() async {
    try {
      final response = await _apiClient.get(
        '/driver/deliveries/completed',
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('deliveries') &&
          response['deliveries'] is List) {
        return List<Map<String, dynamic>>.from(response['deliveries']);
      }

      return [];
    } catch (e) {
      throw _handleDriverError(e);
    }
  }

  // Handle driver-specific errors
  ApiError _handleDriverError(dynamic error) {
    if (error is DioException) {
      // Handle specific driver errors
      if (error.response?.statusCode == 401) {
        return ApiError(
          statusCode: 401,
          message: 'Driver authentication failed. Please login again.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 403) {
        return ApiError(
          statusCode: 403,
          message: 'You are not authorized to perform this action.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 404) {
        return ApiError(
          statusCode: 404,
          message: 'Delivery not found or already taken.',
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
