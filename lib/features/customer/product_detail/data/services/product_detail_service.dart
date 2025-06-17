import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class ProductDetailService {
  final ApiClient _apiClient = ApiClient();
  
  // Singleton pattern
  static final ProductDetailService _instance = ProductDetailService._internal();
  factory ProductDetailService() => _instance;
  ProductDetailService._internal();
  
  // Get product details
  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.productDetail}$productId',
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleProductDetailError(e);
    }
  }
  
  // Get product reviews
  Future<Map<String, dynamic>> getProductReviews({
    required String productId,
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
        '${ApiConstants.productDetail}$productId/reviews',
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleProductDetailError(e);
    }
  }
  
  // Add product review
  Future<Map<String, dynamic>> addProductReview({
    required String productId,
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
        '${ApiConstants.productDetail}$productId/reviews',
        data: data,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleProductDetailError(e);
    }
  }
  
  // Check if user can review product (has purchased before)
  Future<bool> canReviewProduct(String productId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.productDetail}$productId/can-review',
        requiresAuth: true,
      );
      
      if (response is Map && response.containsKey('canReview')) {
        return response['canReview'] == true;
      }
      
      return false;
    } catch (e) {
      throw _handleProductDetailError(e);
    }
  }
  
  // Get related products
  Future<List<Map<String, dynamic>>> getRelatedProducts(String productId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.productDetail}$productId/related',
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('products') && response['products'] is List) {
        return List<Map<String, dynamic>>.from(response['products']);
      }
      
      return [];
    } catch (e) {
      throw _handleProductDetailError(e);
    }
  }
  
  // Check product availability
  Future<bool> checkProductAvailability(String productId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.productDetail}$productId/availability',
        requiresAuth: true,
      );
      
      if (response is Map && response.containsKey('isAvailable')) {
        return response['isAvailable'] == true;
      }
      
      return false;
    } catch (e) {
      throw _handleProductDetailError(e);
    }
  }
  
  // Handle product detail-related errors
  ApiError _handleProductDetailError(dynamic error) {
    // If it's already an ApiError, return it
    if (error is ApiError) {
      return error;
    }
    
    // Default error
    return ApiError(message: error.toString());
  }
}
