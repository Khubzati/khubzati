import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class OrderHistoryService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches order history for the current user
  /// 
  /// [page] is the page number for pagination (starts from 1)
  /// [limit] is the number of orders per page
  /// [status] optional filter for order status (e.g., 'completed', 'processing', 'cancelled')
  /// Returns paginated list of orders with their basic details
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getOrderHistory({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      final response = await _apiClient.get(
        ApiConstants.orders,
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      return {
        'orders': List<Map<String, dynamic>>.from(response['data'] ?? []),
        'pagination': Map<String, dynamic>.from(response['meta']['pagination'] ?? {}),
      };
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Fetches detailed information for a specific order
  /// 
  /// [orderId] is the ID of the order to fetch details for
  /// Returns comprehensive order details including items, pricing, delivery info, etc.
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.orderDetail}$orderId',
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

  /// Fetches tracking information for a specific order
  /// 
  /// [orderId] is the ID of the order to track
  /// Returns order status, location (if applicable), and estimated delivery time
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.orderDetail}$orderId/tracking',
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

  /// Reorders a previous order (creates a new cart with the same items)
  /// 
  /// [orderId] is the ID of the order to reorder
  /// Returns the newly created cart data
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> reorder(String orderId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.orderDetail}$orderId/reorder',
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

  /// Fetches order statistics for the current user
  /// 
  /// Returns statistics like total orders, completed orders, cancelled orders, etc.
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.orders}/statistics',
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

  /// Searches order history with specific criteria
  /// 
  /// [searchTerm] is the term to search for (e.g., order ID, vendor name, product name)
  /// [startDate] optional filter for orders placed after this date
  /// [endDate] optional filter for orders placed before this date
  /// [page] is the page number for pagination
  /// [limit] is the number of orders per page
  /// Returns paginated search results
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> searchOrders({
    required String searchTerm,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'search': searchTerm,
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (startDate != null) {
        queryParams['start_date'] = startDate;
      }
      
      if (endDate != null) {
        queryParams['end_date'] = endDate;
      }
      
      final response = await _apiClient.get(
        '${ApiConstants.orders}/search',
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      return {
        'orders': List<Map<String, dynamic>>.from(response['data'] ?? []),
        'pagination': Map<String, dynamic>.from(response['meta']['pagination'] ?? {}),
      };
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }
}
