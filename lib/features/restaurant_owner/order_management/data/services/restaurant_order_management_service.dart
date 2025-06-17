import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class RestaurantOrderManagementService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches all orders for the restaurant owner
  /// 
  /// [page] is the page number for pagination (starts from 1)
  /// [limit] is the number of orders per page
  /// [status] optional filter for order status (e.g., 'pending', 'processing', 'completed', 'cancelled')
  /// [sortBy] optional sorting field (e.g., 'created_at', 'total_amount')
  /// [sortOrder] optional sorting direction ('asc' or 'desc')
  /// Returns paginated list of orders with their details
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      if (sortBy != null) {
        queryParams['sort_by'] = sortBy;
      }
      
      if (sortOrder != null) {
        queryParams['sort_order'] = sortOrder;
      }
      
      final response = await _apiClient.get(
        ApiConstants.restaurantOrders,
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
  /// Returns comprehensive order details including items, customer info, etc.
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.restaurantOrderDetail}$orderId',
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

  /// Updates the status of an order
  /// 
  /// [orderId] is the ID of the order to update
  /// [status] is the new status for the order (e.g., 'accepted', 'preparing', 'ready_for_pickup', 'completed', 'cancelled')
  /// [notes] optional notes about the status change
  /// Returns the updated order data
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status, {String? notes}) async {
    try {
      final data = {
        'status': status,
      };
      
      if (notes != null) {
        data['notes'] = notes;
      }
      
      final response = await _apiClient.put(
        '${ApiConstants.restaurantOrderDetail}$orderId/status',
        data: data,
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

  /// Assigns a delivery person to an order
  /// 
  /// [orderId] is the ID of the order to assign
  /// [deliveryPersonId] is the ID of the delivery person to assign
  /// Returns the updated order data
  /// Throws [ApiError] if the assignment fails
  Future<Map<String, dynamic>> assignDeliveryPerson(String orderId, String deliveryPersonId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.restaurantOrderDetail}$orderId/assign-delivery',
        data: {'delivery_person_id': deliveryPersonId},
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

  /// Sends notification to customer about order status
  /// 
  /// [orderId] is the ID of the order
  /// [message] is the notification message to send
  /// Returns success status
  /// Throws [ApiError] if sending notification fails
  Future<bool> sendCustomerNotification(String orderId, String message) async {
    try {
      await _apiClient.post(
        '${ApiConstants.restaurantOrderDetail}$orderId/notify-customer',
        data: {'message': message},
        requiresAuth: true,
      );
      
      return true;
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Generates invoice for an order
  /// 
  /// [orderId] is the ID of the order to generate invoice for
  /// Returns invoice data including download URL
  /// Throws [ApiError] if invoice generation fails
  Future<Map<String, dynamic>> generateInvoice(String orderId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.restaurantOrderDetail}$orderId/generate-invoice',
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

  /// Searches orders with specific criteria
  /// 
  /// [searchTerm] is the term to search for (e.g., order ID, customer name, menu item name)
  /// [page] is the page number for pagination
  /// [limit] is the number of orders per page
  /// Returns paginated search results
  /// Throws [ApiError] if the search fails
  Future<Map<String, dynamic>> searchOrders({
    required String searchTerm,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'search': searchTerm,
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      final response = await _apiClient.get(
        '${ApiConstants.restaurantOrders}/search',
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

  /// Fetches order statistics by status
  /// 
  /// Returns count of orders grouped by status
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.restaurantOrders}/statistics',
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
