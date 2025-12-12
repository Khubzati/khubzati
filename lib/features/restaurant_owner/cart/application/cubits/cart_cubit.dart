import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/features/restaurant_owner/cart/domain/models/cart_item.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial());

  void loadCart() {
    emit(const CartLoading());
    try {
      // TODO: Load cart from local storage or backend
      // For now, adding mock items for testing until API is ready
      Future.delayed(const Duration(milliseconds: 200), () {
        final mockItems = _getMockCartItems();
        emit(CartLoaded(items: mockItems));
      });
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  /// Mock cart items for testing until API is ready
  List<CartItem> _getMockCartItems() {
    return [
      CartItem(
        productId: 'mock_product_1',
        productName: 'خبز توست أبيض',
        price: 1.25,
        quantity: 2,
        imageUrl: null, // Will use placeholder
        restaurantId: 'mock_restaurant_1',
        restaurantName: 'مخابز قاسيون',
      ),
      CartItem(
        productId: 'mock_product_2',
        productName: 'خبز عربي',
        price: 0.75,
        quantity: 3,
        imageUrl: null,
        restaurantId: 'mock_restaurant_1',
        restaurantName: 'مخابز قاسيون',
      ),
      CartItem(
        productId: 'mock_product_3',
        productName: 'خبز فرنسي',
        price: 2.50,
        quantity: 1,
        imageUrl: null,
        restaurantId: 'mock_restaurant_2',
        restaurantName: 'مخبز النور',
      ),
    ];
  }

  void addItemToCart(CartItem item) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final List<CartItem> updatedItems = List.from(currentState.items);

      // Check if item already exists
      final existingIndex = updatedItems.indexWhere(
        (cartItem) => cartItem.productId == item.productId,
      );

      if (existingIndex != -1) {
        // Update quantity if item exists
        updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
          quantity: updatedItems[existingIndex].quantity + item.quantity,
        );
      } else {
        // Add new item
        updatedItems.add(item);
      }

      emit(CartLoaded(items: updatedItems));
    } else if (state is CartInitial || state is CartLoading) {
      // If cart wasn't loaded, initialize with mock items and add the new item
      final mockItems = _getMockCartItems();
      final List<CartItem> updatedItems = List.from(mockItems);

      // Check if item already exists in mock items
      final existingIndex = updatedItems.indexWhere(
        (cartItem) => cartItem.productId == item.productId,
      );

      if (existingIndex != -1) {
        // Update quantity if item exists
        updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
          quantity: updatedItems[existingIndex].quantity + item.quantity,
        );
      } else {
        // Add new item
        updatedItems.add(item);
      }

      emit(CartLoaded(items: updatedItems));
    }
  }

  void updateItemQuantity(String productId, int newQuantity) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final List<CartItem> updatedItems = List.from(currentState.items);

      final itemIndex = updatedItems.indexWhere(
        (item) => item.productId == productId,
      );

      if (itemIndex != -1) {
        if (newQuantity > 0) {
          updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
            quantity: newQuantity,
          );
        } else {
          // Remove item if quantity is 0 or less
          updatedItems.removeAt(itemIndex);
        }
        emit(CartLoaded(items: updatedItems));
      }
    }
  }

  void removeItemFromCart(String productId) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final List<CartItem> updatedItems = currentState.items
          .where((item) => item.productId != productId)
          .toList();

      emit(CartLoaded(items: updatedItems));
    }
  }

  void clearCart() {
    emit(const CartLoaded(items: []));
  }
}
