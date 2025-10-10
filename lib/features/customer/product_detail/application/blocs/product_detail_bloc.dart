import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import your models and services here
// e.g., import 'package:khubzati/core/models/product_model.dart';
// import 'package:khubzati/core/services/product_service.dart';
// import 'package:khubzati/features/customer/cart/application/blocs/cart_bloc.dart'; // Assuming CartBloc for AddToCart

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  // final ProductService productService; // Assuming a service to fetch product details
  // final CartBloc cartBloc; // To dispatch AddToCart events to CartBloc

  ProductDetailBloc(/*{required this.productService, required this.cartBloc}*/)
      : super(ProductDetailInitial()) {
    on<FetchProductDetails>(_onFetchProductDetails);
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onFetchProductDetails(
      FetchProductDetails event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      // TODO: Replace with actual API call from productService
      // final product = await productService.getProductDetails(event.productId);

      // Placeholder data
      await Future.delayed(const Duration(milliseconds: 600));
      final product = {
        "id": event.productId,
        "name": "Delicious Croissant ${event.productId}",
        "description":
            "A flaky, buttery croissant, perfect for breakfast or a snack. Made with high-quality ingredients and baked fresh daily.",
        "price": 5.99,
        "images": ["image_url_1.jpg", "image_url_2.jpg", "image_url_3.jpg"],
        // "options": []
      };

      emit(ProductDetailLoaded(
        productId: product["id"] as String,
        productName: product["name"] as String,
        productDescription: product["description"] as String,
        productPrice: product["price"] as double,
        productImages: product["images"] as List<String>,
        // options: product.options,
      ));
    } catch (e) {
      emit(ProductDetailError(
          'Failed to fetch product details: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(
      AddToCart event, Emitter<ProductDetailState> emit) async {
    // This event in ProductDetailBloc might just be to signal the UI (e.g., show a success message)
    // The actual cart logic should be handled by a dedicated CartBloc.
    // Here, we can emit states to reflect the AddToCart action's progress/result locally if needed,
    // or directly call/dispatch an event to the CartBloc.

    emit(AddToCartInProgress());
    try {
      // Option 1: Dispatch event to CartBloc (preferred for separation of concerns)
      // cartBloc.add(AddItemToCart(productId: event.productId, quantity: event.quantity, price: event.productPrice, name: event.productName));

      // Placeholder: Simulate adding to cart and emit success
      await Future.delayed(const Duration(milliseconds: 300));
      print(
          "Product ${event.productName} (ID: ${event.productId}) added to cart with quantity ${event.quantity}.");
      emit(const AddToCartSuccess("Item added to cart!"));

      // Important: After emitting AddToCartSuccess, you might want to revert to ProductDetailLoaded
      // or another appropriate state if the user stays on the product detail page.
      // For simplicity, this example keeps it at AddToCartSuccess. A real app might need to reload product details or navigate.
      // Or, the UI listens to CartBloc for cart updates and ProductDetailBloc for product data.
    } catch (e) {
      emit(AddToCartFailure('Failed to add item to cart: ${e.toString()}'));
    }
  }
}
