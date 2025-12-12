part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double deliveryFee;
  final double tax;

  const CartLoaded({
    required this.items,
    this.deliveryFee = 0.0,
    this.tax = 0.0,
  });

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get total {
    return subtotal + deliveryFee + tax;
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  CartLoaded copyWith({
    List<CartItem>? items,
    double? deliveryFee,
    double? tax,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
    );
  }

  @override
  List<Object> get props => [items, deliveryFee, tax];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

