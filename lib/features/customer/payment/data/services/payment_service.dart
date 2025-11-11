import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

@lazySingleton
class PaymentService {
  final ApiClient _apiClient = ApiClient();

  PaymentService();

  // Process payment for an order
  Future<Map<String, dynamic>> processPayment({
    required String orderId,
    required double amount,
    String? paymentMethodId,
    required String paymentMethod, // 'card', 'cash', 'wallet'
    Map<String, dynamic>? cardDetails,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.paymentProcess,
        data: {
          'order_id': orderId,
          'amount': amount,
          'payment_method_id': paymentMethodId,
          'payment_method': paymentMethod,
          'card_details': cardDetails,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handlePaymentError(e);
    }
  }

  // Check payment status for an order
  Future<Map<String, dynamic>> checkPaymentStatus(String orderId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.paymentStatus}$orderId/status',
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handlePaymentError(e);
    }
  }

  // Get user's saved payment methods
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    try {
      final response = await _apiClient.get(
        '/user/payment-methods',
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('payment_methods') &&
          response['payment_methods'] is List) {
        return List<Map<String, dynamic>>.from(response['payment_methods']);
      }

      return [];
    } catch (e) {
      throw _handlePaymentError(e);
    }
  }

  // Save a new payment method
  Future<Map<String, dynamic>> savePaymentMethod({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardholderName,
    required bool isDefault,
  }) async {
    try {
      final response = await _apiClient.post(
        '/user/payment-methods',
        data: {
          'card_number': cardNumber,
          'expiry_date': expiryDate,
          'cvv': cvv,
          'cardholder_name': cardholderName,
          'is_default': isDefault,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handlePaymentError(e);
    }
  }

  // Delete a payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      await _apiClient.delete(
        '/user/payment-methods/$paymentMethodId',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handlePaymentError(e);
    }
  }

  // Get payment history
  Future<List<Map<String, dynamic>>> getPaymentHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/user/payment-history',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('payments') &&
          response['payments'] is List) {
        return List<Map<String, dynamic>>.from(response['payments']);
      }

      return [];
    } catch (e) {
      throw _handlePaymentError(e);
    }
  }

  // Refund a payment
  Future<Map<String, dynamic>> refundPayment({
    required String transactionId,
    required double amount,
    String? reason,
  }) async {
    try {
      final response = await _apiClient.post(
        '/payments/refund',
        data: {
          'transaction_id': transactionId,
          'amount': amount,
          'reason': reason,
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handlePaymentError(e);
    }
  }

  // Handle payment-specific errors
  ApiError _handlePaymentError(dynamic error) {
    if (error is DioException) {
      // Handle specific payment errors
      if (error.response?.statusCode == 400) {
        return ApiError(
          statusCode: 400,
          message: 'Invalid payment information. Please check your details.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 402) {
        return ApiError(
          statusCode: 402,
          message: 'Payment failed. Please try a different payment method.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 403) {
        return ApiError(
          statusCode: 403,
          message: 'Payment not authorized. Please contact support.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 404) {
        return ApiError(
          statusCode: 404,
          message: 'Order not found or payment already processed.',
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
