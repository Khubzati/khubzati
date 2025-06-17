import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class VendorDetailService {
  final ApiClient _apiClient = ApiClient();
  
  // Singleton pattern
  static final VendorDetailService _instance = VendorDetailService._internal();
  factory VendorDetailService() => _instance;
  VendorDetailService._internal();
  
  // Get vendor details
  Future<Map<String, dynamic>> getVendorDetails(String vendorId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.vendorDetail}$vendorId',
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleVendorDetailError(e);
    }
  }
  
  // Get vendor products
  Future<Map<String, dynamic>> getVendorProducts({
    required String vendorId,
    String? categoryId,
    String? searchQuery,
    String? sortBy, // 'price', 'popularity', 'name'
    String? sortOrder, // 'asc' or 'desc'
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (searchQuery != null) queryParams['search'] = searchQuery;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;
      
      final response = await _apiClient.get(
        '${ApiConstants.vendorDetail}$vendorId/products',
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleVendorDetailError(e);
    }
  }
  
  // Get vendor product categories
  Future<List<Map<String, dynamic>>> getVendorProductCategories(String vendorId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.vendorDetail}$vendorId/categories',
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('categories') && response['categories'] is List) {
        return List<Map<String, dynamic>>.from(response['categories']);
      }
      
      return [];
    } catch (e) {
      throw _handleVendorDetailError(e);
    }
  }
  
  // Get vendor reviews
  Future<Map<String, dynamic>> getVendorReviews({
    required String vendorId,
    String? sortBy, // 'date', 'rating'
    String? sortOrder, // 'asc' or 'desc'
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;
      
      final response = await _apiClient.get(
        '${ApiConstants.vendorDetail}$vendorId/reviews',
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleVendorDetailError(e);
    }
  }
  
  // Add vendor review
  Future<Map<String, dynamic>> addVendorReview({
    required String vendorId,
    required double rating,
    required String comment,
    List<String>? images,
  }) async {
    try {
      final data = <String, dynamic>{
        'rating': rating,
        'comment': comment,
      };
      
      if (images != null && images.isNotEmpty) {
        data['images'] = images;
      }
      
      final response = await _apiClient.post(
        '${ApiConstants.vendorDetail}$vendorId/reviews',
        data: data,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleVendorDetailError(e);
    }
  }
  
  // Check if user can review vendor (has ordered before)
  Future<bool> canReviewVendor(String vendorId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.vendorDetail}$vendorId/can-review',
        requiresAuth: true,
      );
      
      if (response is Map && response.containsKey('canReview')) {
        return response['canReview'] == true;
      }
      
      return false;
    } catch (e) {
      throw _handleVendorDetailError(e);
    }
  }
  
  // Handle vendor detail-related errors
  ApiError _handleVendorDetailError(dynamic error) {
    // If it's already an ApiError, return it
    if (error is ApiError) {
      return error;
    }
    
    // Default error
    return ApiError(message: error.toString());
  }
}
