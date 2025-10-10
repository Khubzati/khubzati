import 'package:dio/dio.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class ReviewService {
  final ApiClient _apiClient = ApiClient();

  // Singleton pattern
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  // Get reviews for a specific entity (product, restaurant, bakery)
  Future<List<Map<String, dynamic>>> getReviews({
    required String entityType, // 'product', 'restaurant', 'bakery'
    required String entityId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      String endpoint;
      switch (entityType) {
        case 'product':
          endpoint = '${ApiConstants.productReviews}$entityId/reviews';
          break;
        case 'restaurant':
          endpoint = '${ApiConstants.restaurantReviews}$entityId/reviews';
          break;
        case 'bakery':
          endpoint = '${ApiConstants.bakeryReviews}$entityId/reviews';
          break;
        default:
          throw Exception('Invalid entity type: $entityType');
      }

      final response = await _apiClient.get(
        endpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('reviews') &&
          response['reviews'] is List) {
        return List<Map<String, dynamic>>.from(response['reviews']);
      }

      return [];
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  // Get average rating for an entity
  Future<double> getAverageRating({
    required String entityType,
    required String entityId,
  }) async {
    try {
      String endpoint;
      switch (entityType) {
        case 'product':
          endpoint = '${ApiConstants.productReviews}$entityId/rating';
          break;
        case 'restaurant':
          endpoint = '${ApiConstants.restaurantReviews}$entityId/rating';
          break;
        case 'bakery':
          endpoint = '${ApiConstants.bakeryReviews}$entityId/rating';
          break;
        default:
          throw Exception('Invalid entity type: $entityType');
      }

      final response = await _apiClient.get(
        endpoint,
        requiresAuth: true,
      );

      if (response is Map && response.containsKey('average_rating')) {
        return (response['average_rating'] ?? 0.0).toDouble();
      }

      return 0.0;
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  // Add a new review
  Future<Map<String, dynamic>> addReview({
    required String entityType,
    required String entityId,
    required double rating,
    required String comment,
    String? orderId,
  }) async {
    try {
      String endpoint;
      switch (entityType) {
        case 'product':
          endpoint = '${ApiConstants.productReviews}$entityId/reviews';
          break;
        case 'restaurant':
          endpoint = '${ApiConstants.restaurantReviews}$entityId/reviews';
          break;
        case 'bakery':
          endpoint = '${ApiConstants.bakeryReviews}$entityId/reviews';
          break;
        default:
          throw Exception('Invalid entity type: $entityType');
      }

      final response = await _apiClient.post(
        endpoint,
        data: {
          'rating': rating,
          'comment': comment,
          'order_id': orderId,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  // Update an existing review
  Future<Map<String, dynamic>> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    try {
      final response = await _apiClient.put(
        '/reviews/$reviewId',
        data: {
          'rating': rating,
          'comment': comment,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  // Delete a review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _apiClient.delete(
        '/reviews/$reviewId',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  // Get user's reviews
  Future<List<Map<String, dynamic>>> getUserReviews({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/user/reviews',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('reviews') &&
          response['reviews'] is List) {
        return List<Map<String, dynamic>>.from(response['reviews']);
      }

      return [];
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  // Get review statistics
  Future<Map<String, dynamic>> getReviewStats({
    required String entityType,
    required String entityId,
  }) async {
    try {
      String endpoint;
      switch (entityType) {
        case 'product':
          endpoint = '${ApiConstants.productReviews}$entityId/stats';
          break;
        case 'restaurant':
          endpoint = '${ApiConstants.restaurantReviews}$entityId/stats';
          break;
        case 'bakery':
          endpoint = '${ApiConstants.bakeryReviews}$entityId/stats';
          break;
        default:
          throw Exception('Invalid entity type: $entityType');
      }

      final response = await _apiClient.get(
        endpoint,
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  // Report a review
  Future<void> reportReview({
    required String reviewId,
    required String reason,
    String? description,
  }) async {
    try {
      await _apiClient.post(
        '/reviews/$reviewId/report',
        data: {
          'reason': reason,
          'description': description,
        },
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  // Handle review-specific errors
  ApiError _handleReviewError(dynamic error) {
    if (error is DioException) {
      // Handle specific review errors
      if (error.response?.statusCode == 400) {
        return ApiError(
          statusCode: 400,
          message: 'Invalid review data. Please check your input.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 403) {
        return ApiError(
          statusCode: 403,
          message: 'You can only review items you have ordered.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 404) {
        return ApiError(
          statusCode: 404,
          message: 'Review not found.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 409) {
        return ApiError(
          statusCode: 409,
          message: 'You have already reviewed this item.',
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
