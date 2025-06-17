part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchProductDetails extends ProductDetailEvent {
  final String productId;
  const FetchProductDetails({required this.productId});

  @override
  List<Object> get props => [productId];
}

class AddToCart extends ProductDetailEvent {
  // final ProductModel product;
  // final int quantity;
  final String productId;
  final String productName;
  final double productPrice;
  final int quantity;

  const AddToCart({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, productName, productPrice, quantity];
}

