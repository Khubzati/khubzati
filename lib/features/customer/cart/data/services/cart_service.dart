import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class CartService {
  final ApiClient _apiClient = ApiClient();
  
  // Singleton pattern
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();
  
  // Get cart items
  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.cart,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleCartError(e);
    }
  }
  
  // Add item to cart
  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
    Map<String, dynamic>? customizations,
  }) async {
    try {
      final data = <String, dynamic>{
        'productId': productId,
        'quantity': quantity,
      };
      
      if (customizations != null) {
        data['customizations'] = customizations;
      }
      
      final response = await _apiClient.post(
        ApiConstants.cart,
        data: data,
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleCartError(e);
    }
  }
  
  // Update cart item quantity
  Future<Map<String, dynamic>> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.cart}/$cartItemId',
        data: {'quantity': quantity},
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleCartError(e);
    }
  }
  
  // Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.cart}/$cartItemId',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleCartError(e);
    }
  }
  
  // Clear cart
  Future<void> clearCart() async {
    try {
      await _apiClient.delete(
        ApiConstants.cart,
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleCartError(e);
    }
  }
  
  // Apply promo code
  Future<Map<String, dynamic>> applyPromoCode(String promoCode) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.cart}/promo-code',
        data: {'code': promoCode},
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleCartError(e);
    }
  }
  
  // Remove promo code
  Future<void> removePromoCode() async {
    try {
      await _apiClient.delete(
        '${ApiConstants.cart}/promo-code',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleCartError(e);
    }
  }
  
  // Get cart summary (total, subtotal, tax, delivery fee, etc.)
  Future<Map<String, dynamic>> getCartSummary() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.cart}/summary',
        requiresAuth: true,
      );
      
      return response;
    } catch (e) {
      throw _handleCartError(e);
    }
  }
  
  // Handle cart-related errors
  ApiError _handleCartError(dynamic error) {
    // If it's already an ApiError, return it
    if (error is ApiError) {
      return error;
    }
    
    // Default error
    return ApiError(message: error.toString());
  }
}
