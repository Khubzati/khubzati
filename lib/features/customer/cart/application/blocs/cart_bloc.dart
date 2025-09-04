import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import your models and services here
// e.g., import 'package:khubzati/core/models/cart_item_model.dart';
// import 'package:khubzati/core/services/cart_service.dart'; // For backend cart sync

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  // final CartService cartService; // Optional: if cart is synced with backend

  CartBloc(/*{this.cartService}*/) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      // TODO: Load cart from local storage (e.g., AppPreferences) or backend (via cartService)
      // For now, starting with an empty cart or pre-populating for testing
      await Future.delayed(
          const Duration(milliseconds: 200)); // Simulate loading
      // final Map<String, Map<String, dynamic>> loadedItems = await appPreferences.getCartItems();
      // emit(_calculateTotals(CartLoaded(items: loadedItems)));
      emit(const CartLoaded(
          items: {}, subtotal: 0.0, total: 0.0)); // Start with empty cart
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  void _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final Map<String, Map<String, dynamic>> updatedItems =
          Map.from(currentState.items);

      if (updatedItems.containsKey(event.productId)) {
        // Item already exists, update quantity
        final existingItem = updatedItems[event.productId]!;
        updatedItems[event.productId] = {
          ...existingItem,
          'quantity': existingItem['quantity'] + event.quantity,
        };
      } else {
        // Add new item
        updatedItems[event.productId] = {
          'productId': event.productId,
          'name': event.productName,
          'price': event.productPrice,
          'quantity': event.quantity,
          'imageUrl': event.productImageUrl,
        };
      }
      // TODO: Persist updatedItems to local storage or sync with backend
      emit(_calculateTotals(CartLoaded(items: updatedItems)));
    } else if (state is CartInitial || state is CartLoading) {
      // If cart wasn't loaded, create a new cart with this item
      final Map<String, Map<String, dynamic>> newItems = {};
      newItems[event.productId] = {
        'productId': event.productId,
        'name': event.productName,
        'price': event.productPrice,
        'quantity': event.quantity,
        'imageUrl': event.productImageUrl,
      };
      emit(_calculateTotals(CartLoaded(items: newItems)));
    }
  }

  void _onUpdateCartItemQuantity(
      UpdateCartItemQuantity event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final Map<String, Map<String, dynamic>> updatedItems =
          Map.from(currentState.items);

      if (updatedItems.containsKey(event.productId)) {
        if (event.newQuantity > 0) {
          updatedItems[event.productId]!['quantity'] = event.newQuantity;
        } else {
          // If new quantity is 0 or less, remove the item
          updatedItems.remove(event.productId);
        }
        // TODO: Persist updatedItems
        emit(_calculateTotals(CartLoaded(items: updatedItems)));
      }
    }
  }

  void _onRemoveItemFromCart(
      RemoveItemFromCart event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final Map<String, Map<String, dynamic>> updatedItems =
          Map.from(currentState.items);

      updatedItems.remove(event.productId);
      // TODO: Persist updatedItems
      emit(_calculateTotals(CartLoaded(items: updatedItems)));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    // TODO: Clear cart from persistence
    emit(const CartLoaded(items: {}, subtotal: 0.0, total: 0.0));
  }

  // Helper function to calculate totals
  CartLoaded _calculateTotals(CartLoaded cart) {
    double subtotal = 0.0;
    cart.items.forEach((_, itemData) {
      subtotal += (itemData['price'] as double) * (itemData['quantity'] as int);
    });

    // TODO: Add logic for delivery fees, taxes, discounts, etc.
    double total = subtotal; // For now, total is same as subtotal

    return cart.copyWith(subtotal: subtotal, total: total);
  }
}
