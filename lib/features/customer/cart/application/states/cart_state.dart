part of 'cart_bloc.dart';

// Assuming a CartItem model that might look like this:
// class CartItem extends Equatable {
//   final String productId;
//   final String name;
//   final double price;
//   final int quantity;
//   final String? imageUrl;
//
//   const CartItem({
//     required this.productId,
//     required this.name,
//     required this.price,
//     required this.quantity,
//     this.imageUrl,
//   });
//
//   CartItem copyWith({int? quantity}) {
//     return CartItem(
//       productId: productId,
//       name: name,
//       price: price,
//       quantity: quantity ?? this.quantity,
//       imageUrl: imageUrl,
//     );
//   }
//
//   @override
//   List<Object?> get props => [productId, name, price, quantity, imageUrl];
// }

// Using a Map for cart items for placeholder simplicity for now
// Key: productId, Value: Map representing CartItem details

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Map<String, Map<String, dynamic>> items; // ProductId -> CartItemData
  final double subtotal;
  final double total;
  // Add other fields like deliveryFee, taxes if calculated here

  const CartLoaded({
    this.items = const {},
    this.subtotal = 0.0,
    this.total = 0.0,
  });

  CartLoaded copyWith({
    Map<String, Map<String, dynamic>>? items,
    double? subtotal,
    double? total,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
    );
  }

  @override
  List<Object> get props => [items, subtotal, total];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

