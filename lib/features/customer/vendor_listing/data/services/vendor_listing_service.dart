import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class VendorListingService {
  final ApiClient _apiClient = ApiClient();
  
  // Singleton pattern
  static final VendorListingService _instance = VendorListingService._internal();
  factory VendorListingService() => _instance;
  VendorListingService._internal();
  
  // Get vendors list with filtering and sorting
  Future<Map<String, dynamic>> getVendors({
    String? type, // 'bakery' or 'restaurant'
    String? searchQuery,
    String? sortBy, // 'rating', 'distance', 'deliveryTime', 'priceRange'
    String? sortOrder, // 'asc' or 'desc'
    double? minRating,
    double? maxDeliveryTime,
    String? priceRange, // 'low', 'medium', 'high'
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (type != null) queryParams['type'] = type;
      if (searchQuery != null) queryParams['search'] = searchQuery;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;
      if (minRating != null) queryParams['minRating'] = minRating.toString();
      if (maxDeliveryTime != null) queryParams['maxDeliveryTime'] = maxDeliveryTime.toString();
      if (priceRange != null) queryParams['priceRange'] = priceRange;
      if (latitude != null) queryParams['latitude'] = latitude.toString();
      if (longitude != null) queryParams['longitude'] = longitude.toString();
      
      final response = await _apiClient.get(
        ApiConstants.vendors,
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleVendorError(e);
    }
  }
  
  // Get bakery vendors
  Future<Map<String, dynamic>> getBakeryVendors({
    String? searchQuery,
    String? sortBy,
    String? sortOrder,
    double? minRating,
    double? maxDeliveryTime,
    String? priceRange,
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 10,
  }) async {
    return getVendors(
      type: 'bakery',
      searchQuery: searchQuery,
      sortBy: sortBy,
      sortOrder: sortOrder,
      minRating: minRating,
      maxDeliveryTime: maxDeliveryTime,
      priceRange: priceRange,
      latitude: latitude,
      longitude: longitude,
      page: page,
      limit: limit,
    );
  }
  
  // Get restaurant vendors
  Future<Map<String, dynamic>> getRestaurantVendors({
    String? searchQuery,
    String? sortBy,
    String? sortOrder,
    double? minRating,
    double? maxDeliveryTime,
    String? priceRange,
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 10,
  }) async {
    return getVendors(
      type: 'restaurant',
      searchQuery: searchQuery,
      sortBy: sortBy,
      sortOrder: sortOrder,
      minRating: minRating,
      maxDeliveryTime: maxDeliveryTime,
      priceRange: priceRange,
      latitude: latitude,
      longitude: longitude,
      page: page,
      limit: limit,
    );
  }
  
  // Get vendor categories (for filtering)
  Future<List<Map<String, dynamic>>> getVendorCategories(String type) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.vendors}/categories',
        queryParameters: {'type': type},
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('categories') && response['categories'] is List) {
        return List<Map<String, dynamic>>.from(response['categories']);
      }
      
      return [];
    } catch (e) {
      throw _handleVendorError(e);
    }
  }
  
  // Handle vendor-related errors
  ApiError _handleVendorError(dynamic error) {
    // If it's already an ApiError, return it
    if (error is ApiError) {
      return error;
    }
    
    // Default error
    return ApiError(message: error.toString());
  }
}
