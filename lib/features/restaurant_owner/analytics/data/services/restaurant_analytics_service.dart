import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class RestaurantAnalyticsService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches sales overview for the restaurant
  ///
  /// [period] can be 'today', 'week', 'month', 'year'
  /// Returns sales overview data including total sales, orders, and average order value
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getSalesOverview({
    required String period,
  }) async {
    try {
      final queryParams = {
        'period': period,
      };

      final response = await _apiClient.get(
        '${ApiConstants.restaurantAnalytics}/sales-overview',
        queryParameters: queryParams,
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

  /// Fetches order statistics for the restaurant
  ///
  /// [period] can be 'today', 'week', 'month', 'year'
  /// Returns order statistics grouped by status
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getOrderStatistics({
    required String period,
  }) async {
    try {
      final queryParams = {
        'period': period,
      };

      final response = await _apiClient.get(
        '${ApiConstants.restaurantAnalytics}/order-statistics',
        queryParameters: queryParams,
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

  /// Fetches popular items for the restaurant
  ///
  /// [period] can be 'today', 'week', 'month', 'year'
  /// [limit] is the number of items to return (default: 10)
  /// Returns list of popular items with sales data
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getPopularItems({
    required String period,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'period': period,
        'limit': limit.toString(),
      };

      final response = await _apiClient.get(
        '${ApiConstants.restaurantAnalytics}/popular-items',
        queryParameters: queryParams,
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

  /// Fetches revenue breakdown by category
  ///
  /// [period] can be 'today', 'week', 'month', 'year'
  /// Returns revenue breakdown data by product categories
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getRevenueBreakdown({
    required String period,
  }) async {
    try {
      final queryParams = {
        'period': period,
      };

      final response = await _apiClient.get(
        '${ApiConstants.restaurantAnalytics}/revenue-breakdown',
        queryParameters: queryParams,
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

  /// Fetches order trends over time
  ///
  /// [period] can be 'today', 'week', 'month', 'year'
  /// [granularity] can be 'hour', 'day', 'week', 'month'
  /// Returns order trends data for charts
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getOrderTrends({
    required String period,
    String granularity = 'day',
  }) async {
    try {
      final queryParams = {
        'period': period,
        'granularity': granularity,
      };

      final response = await _apiClient.get(
        '${ApiConstants.restaurantAnalytics}/order-trends',
        queryParameters: queryParams,
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

  /// Fetches customer insights
  ///
  /// [period] can be 'today', 'week', 'month', 'year'
  /// Returns customer insights including new vs returning customers
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getCustomerInsights({
    required String period,
  }) async {
    try {
      final queryParams = {
        'period': period,
      };

      final response = await _apiClient.get(
        '${ApiConstants.restaurantAnalytics}/customer-insights',
        queryParameters: queryParams,
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

  /// Exports analytics report
  ///
  /// [period] can be 'today', 'week', 'month', 'year'
  /// [format] can be 'pdf', 'excel', 'csv'
  /// Returns file path and download information
  /// Throws [ApiError] if the export fails
  Future<Map<String, dynamic>> exportAnalyticsReport({
    required String period,
    String format = 'pdf',
  }) async {
    try {
      final queryParams = {
        'period': period,
        'format': format,
      };

      final response = await _apiClient.get(
        '${ApiConstants.restaurantAnalytics}/export',
        queryParameters: queryParams,
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
}
