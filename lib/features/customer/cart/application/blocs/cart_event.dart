part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  // final ProductModel item; // Or specific fields
  final String productId;
  final String productName;
  final double productPrice;
  final int quantity;
  final String? productImageUrl; // Optional

  const AddItemToCart({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    this.productImageUrl,
  });

  @override
  List<Object> get props => [productId, productName, productPrice, quantity];
}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int newQuantity;

  const UpdateCartItemQuantity(
      {required this.productId, required this.newQuantity});

  @override
  List<Object> get props => [productId, newQuantity];
}

class RemoveItemFromCart extends CartEvent {
  final String productId;

  const RemoveItemFromCart({required this.productId});

  @override
  List<Object> get props => [productId];
}

class ClearCart extends CartEvent {}
