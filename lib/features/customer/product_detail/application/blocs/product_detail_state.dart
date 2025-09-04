part of 'product_detail_bloc.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  // final ProductModel product;
  // Using placeholders for now
  final String productId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final List<String> productImages;
  // final List<ProductOptionModel> options; // If product has options like size, color

  const ProductDetailLoaded({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImages,
    // required this.options,
  });

  @override
  List<Object> get props => [productId, productName, productDescription, productPrice, productImages];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// State for AddToCart operation
class AddToCartInProgress extends ProductDetailState {}

class AddToCartSuccess extends ProductDetailState {
  final String message;
  const AddToCartSuccess(this.message);

   @override
  List<Object> get props => [message];
}

class AddToCartFailure extends ProductDetailState {
  final String message;
  const AddToCartFailure(this.message);

   @override
  List<Object> get props => [message];
}

