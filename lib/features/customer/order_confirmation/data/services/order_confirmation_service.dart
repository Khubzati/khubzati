import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class OrderConfirmationService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches order confirmation details by order ID
  /// 
  /// [orderId] is the ID of the order to fetch confirmation details for
  /// Returns detailed order confirmation information
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getOrderConfirmation(String orderId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.orderDetail}$orderId/confirmation',
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

  /// Sends order confirmation receipt to user's email
  /// 
  /// [orderId] is the ID of the order to send receipt for
  /// [email] is the email address to send the receipt to (optional, uses user's email if not provided)
  /// Returns success status
  /// Throws [ApiError] if the request fails
  Future<bool> sendOrderReceipt(String orderId, {String? email}) async {
    try {
      final data = email != null ? {'email': email} : null;
      
      await _apiClient.post(
        '${ApiConstants.orderDetail}$orderId/send-receipt',
        data: data,
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

  /// Confirms receipt of order by customer
  /// 
  /// [orderId] is the ID of the order to confirm receipt for
  /// Returns updated order status
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> confirmOrderReceipt(String orderId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.orderDetail}$orderId/confirm-receipt',
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

  /// Submits a review for the order
  /// 
  /// [orderId] is the ID of the order to review
  /// [reviewData] contains rating, comments, and other review details
  /// Returns the submitted review data
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> submitOrderReview(String orderId, Map<String, dynamic> reviewData) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.orderDetail}$orderId/review',
        data: reviewData,
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

  /// Reports an issue with the order
  /// 
  /// [orderId] is the ID of the order to report an issue for
  /// [issueData] contains issue type, description, and any supporting details
  /// Returns the created issue ticket information
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> reportOrderIssue(String orderId, Map<String, dynamic> issueData) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.orderDetail}$orderId/report-issue',
        data: issueData,
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

  /// Cancels an order (if cancellation is still allowed)
  /// 
  /// [orderId] is the ID of the order to cancel
  /// [reason] is the reason for cancellation
  /// Returns updated order status
  /// Throws [ApiError] if cancellation fails or is not allowed
  Future<Map<String, dynamic>> cancelOrder(String orderId, String reason) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.orderDetail}$orderId/cancel',
        data: {'reason': reason},
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
