import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement ProductDetailBloc for state management and API calls
// TODO: Implement UI for Product Images (carousel), Description, Price, Quantity selection, Add to Cart button
// TODO: Implement Add to Cart logic (potentially via a CartBloc)

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-detail';
  final String productId; // Passed from VendorDetailScreen or ProductList

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  void _addToCart() {
    // TODO: Call CartBloc or relevant service to add product to cart with selected quantity
    print('Added ${widget.productId} to cart with quantity: $_quantity');
    // TODO: Show confirmation (e.g., SnackBar) and/or navigate to CartScreen or back
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch product details using widget.productId via ProductDetailBloc
    return Scaffold(
      appBar: AppBar(
        // Title can be dynamic based on product name fetched
        title: Text(
            LocaleKeys.product_detail_title.tr()), // Assuming this key exists
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TODO: Implement Product Image Carousel
              Container(
                height: 250,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Text(
                    "Product Image Carousel Placeholder (ID: ${widget.productId})",
                    style: context.theme.textTheme.titleMedium),
              ),
              const SizedBox(height: 24),

              // TODO: Implement Product Name (fetched from Bloc)
              Text("Product Name Placeholder",
                  style: context.theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // TODO: Implement Product Price (fetched from Bloc)
              Text("SAR 0.00",
                  style: context.theme.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // TODO: Implement Product Description (fetched from Bloc)
              Text(
                "Product description placeholder. This will contain detailed information about the product, its ingredients, preparation, etc.",
                style: context.theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              // Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _decrementQuantity,
                      iconSize: 30),
                  Text('$_quantity',
                      style: context.theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _incrementQuantity,
                      iconSize: 30),
                ],
              ),
              const SizedBox(height: 24),

              // Add to Cart Button
              AppElevatedButton(
                text: LocaleKeys.product_detail_add_to_cart_button
                    .tr(), // Assuming this key exists
                onPressed: _addToCart,
                // TODO: Style button as per Figma
              ),
              const SizedBox(height: 24),

              // TODO: Implement sections like 'Related Products' or 'Reviews' if in Figma
            ],
          ),
        ),
      ),
    );
  }
}
