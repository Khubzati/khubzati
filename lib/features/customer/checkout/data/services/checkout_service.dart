import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class CheckoutService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches available delivery addresses for the current user
  /// 
  /// Returns a list of addresses with their details
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getDeliveryAddresses() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userAddresses,
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

  /// Adds a new delivery address for the current user
  /// 
  /// [addressData] should contain all required address fields
  /// Returns the newly created address data
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> addDeliveryAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.userAddresses,
        data: addressData,
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

  /// Updates an existing delivery address
  /// 
  /// [addressId] is the ID of the address to update
  /// [addressData] contains the updated address fields
  /// Returns the updated address data
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> updateDeliveryAddress(String addressId, Map<String, dynamic> addressData) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.userAddresses}/$addressId',
        data: addressData,
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

  /// Deletes a delivery address
  /// 
  /// [addressId] is the ID of the address to delete
  /// Returns true if deletion was successful
  /// Throws [ApiError] if the request fails
  Future<bool> deleteDeliveryAddress(String addressId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.userAddresses}/$addressId',
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

  /// Fetches available payment methods
  /// 
  /// Returns a list of payment methods with their details
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.checkout}/payment-methods',
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

  /// Validates the checkout data before placing an order
  /// 
  /// [checkoutData] contains cart items, selected address, payment method, etc.
  /// Returns validation result with any price adjustments or warnings
  /// Throws [ApiError] if validation fails
  Future<Map<String, dynamic>> validateCheckout(Map<String, dynamic> checkoutData) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.checkout}/validate',
        data: checkoutData,
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

  /// Places an order with the provided checkout data
  /// 
  /// [checkoutData] contains cart items, selected address, payment method, etc.
  /// Returns the created order details including order ID and payment information
  /// Throws [ApiError] if order placement fails
  Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> checkoutData) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.checkout,
        data: checkoutData,
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

  /// Processes payment for an order
  /// 
  /// [orderId] is the ID of the order to process payment for
  /// [paymentData] contains payment details like token, method, etc.
  /// Returns payment processing result
  /// Throws [ApiError] if payment processing fails
  Future<Map<String, dynamic>> processPayment(String orderId, Map<String, dynamic> paymentData) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.checkout}/payment/$orderId',
        data: paymentData,
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

  /// Calculates delivery fees based on address and cart items
  /// 
  /// [addressId] is the ID of the delivery address
  /// [cartItems] contains the items in the cart
  /// Returns calculated delivery fees and estimated delivery time
  /// Throws [ApiError] if calculation fails
  Future<Map<String, dynamic>> calculateDeliveryFees(String addressId, List<Map<String, dynamic>> cartItems) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.checkout}/delivery-fees',
        data: {
          'address_id': addressId,
          'cart_items': cartItems,
        },
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
