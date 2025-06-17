import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class BakeryDashboardService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches dashboard summary data for bakery owner
  /// 
  /// Returns dashboard summary including sales, orders, products stats
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.bakeryDashboard,
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

  /// Fetches sales statistics for a specific time period
  /// 
  /// [period] can be 'daily', 'weekly', 'monthly', 'yearly'
  /// [startDate] optional filter for statistics after this date
  /// [endDate] optional filter for statistics before this date
  /// Returns sales statistics for the specified period
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getSalesStatistics({
    required String period,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = {
        'period': period,
      };
      
      if (startDate != null) {
        queryParams['start_date'] = startDate;
      }
      
      if (endDate != null) {
        queryParams['end_date'] = endDate;
      }
      
      final response = await _apiClient.get(
        '${ApiConstants.bakeryDashboard}/sales',
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

  /// Fetches recent orders for the bakery dashboard
  /// 
  /// [limit] is the number of recent orders to fetch
  /// Returns list of recent orders with basic details
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getRecentOrders({int limit = 5}) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.bakeryDashboard}/recent-orders',
        queryParameters: {'limit': limit.toString()},
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

  /// Fetches top selling products for the bakery
  /// 
  /// [limit] is the number of top products to fetch
  /// [period] optional filter for a specific time period ('week', 'month', 'year')
  /// Returns list of top selling products with sales data
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getTopSellingProducts({
    int limit = 5,
    String? period,
  }) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
      };
      
      if (period != null) {
        queryParams['period'] = period;
      }
      
      final response = await _apiClient.get(
        '${ApiConstants.bakeryDashboard}/top-products',
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

  /// Fetches customer demographics data
  /// 
  /// Returns customer demographics information (age groups, gender, location, etc.)
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getCustomerDemographics() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.bakeryDashboard}/customer-demographics',
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

  /// Fetches revenue forecast for upcoming period
  /// 
  /// [period] can be 'week', 'month', 'quarter'
  /// Returns revenue forecast data
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getRevenueForecast(String period) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.bakeryDashboard}/revenue-forecast',
        queryParameters: {'period': period},
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

  /// Fetches inventory status for bakery products
  /// 
  /// Returns inventory status including low stock items
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getInventoryStatus() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.bakeryDashboard}/inventory',
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
