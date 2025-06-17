import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class HomeService {
  final ApiClient _apiClient = ApiClient();
  
  // Singleton pattern
  static final HomeService _instance = HomeService._internal();
  factory HomeService() => _instance;
  HomeService._internal();
  
  // Get home data (banners, categories, popular vendors)
  Future<Map<String, dynamic>> getHomeData() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.home,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleHomeError(e);
    }
  }
  
  // Get banners
  Future<List<Map<String, dynamic>>> getBanners() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.home}/banners',
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('banners') && response['banners'] is List) {
        return List<Map<String, dynamic>>.from(response['banners']);
      }
      
      return [];
    } catch (e) {
      throw _handleHomeError(e);
    }
  }
  
  // Get categories (bakery/restaurant)
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.home}/categories',
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('categories') && response['categories'] is List) {
        return List<Map<String, dynamic>>.from(response['categories']);
      }
      
      return [];
    } catch (e) {
      throw _handleHomeError(e);
    }
  }
  
  // Get popular vendors
  Future<List<Map<String, dynamic>>> getPopularVendors({
    String? type, // 'bakery' or 'restaurant'
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (type != null) {
        queryParams['type'] = type;
      }
      
      final response = await _apiClient.get(
        '${ApiConstants.home}/popular-vendors',
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('vendors') && response['vendors'] is List) {
        return List<Map<String, dynamic>>.from(response['vendors']);
      }
      
      return [];
    } catch (e) {
      throw _handleHomeError(e);
    }
  }
  
  // Get nearby vendors
  Future<List<Map<String, dynamic>>> getNearbyVendors({
    String? type, // 'bakery' or 'restaurant'
    double? latitude,
    double? longitude,
    double radius = 5.0, // in kilometers
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'radius': radius.toString(),
      };
      
      if (type != null) {
        queryParams['type'] = type;
      }
      
      if (latitude != null && longitude != null) {
        queryParams['latitude'] = latitude.toString();
        queryParams['longitude'] = longitude.toString();
      }
      
      final response = await _apiClient.get(
        '${ApiConstants.home}/nearby-vendors',
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('vendors') && response['vendors'] is List) {
        return List<Map<String, dynamic>>.from(response['vendors']);
      }
      
      return [];
    } catch (e) {
      throw _handleHomeError(e);
    }
  }
  
  // Search vendors and products
  Future<Map<String, dynamic>> search({
    required String query,
    String? type, // 'bakery' or 'restaurant'
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (type != null) {
        queryParams['type'] = type;
      }
      
      final response = await _apiClient.get(
        '${ApiConstants.home}/search',
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleHomeError(e);
    }
  }
  
  // Handle home-related errors
  ApiError _handleHomeError(dynamic error) {
    // If it's already an ApiError, return it
    if (error is ApiError) {
      return error;
    }
    
    // Default error
    return ApiError(message: error.toString());
  }
}
