import 'package:flutter/material.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement VendorDetailBloc for state management and API calls
// TODO: Implement UI for Vendor Info, Product Categories, Product List, Reviews
// TODO: Implement navigation to ProductDetailScreen

class VendorDetailScreen extends StatelessWidget {
  static const String routeName = '/vendor-detail';
  final String vendorId; // Passed from VendorListingScreen

  const VendorDetailScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch vendor details using vendorId via VendorDetailBloc
    return Scaffold(
      appBar: AppBar(
        // Title can be dynamic based on vendor name fetched
        title: Text(
            LocaleKeys.vendor_detail_title.tr()), // Assuming this key exists
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TODO: Implement Vendor Header (Image, Name, Rating, etc.)
              Text("Vendor Header Placeholder (ID: $vendorId)",
                  style: context.theme.textTheme.headlineSmall),
              const SizedBox(height: 16),

              // TODO: Implement Vendor Information Section (Description, Address, Hours)
              Text("Vendor Information Placeholder",
                  style: context.theme.textTheme.titleMedium),
              const SizedBox(height: 24),

              // TODO: Implement Product Categories Section (Tabs or List)
              Text(LocaleKeys.vendor_detail_product_categories_title.tr(),
                  style: context
                      .theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 16),
              Text("Product Categories Placeholder",
                  style: context.theme.textTheme.titleMedium),
              const SizedBox(height: 24),

              // TODO: Implement Product List Section (based on selected category)
              Text(LocaleKeys.vendor_detail_products_title.tr(),
                  style: context
                      .theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 16),
              // Placeholder for product list - to be replaced with a ListView.builder and ProductCard widgets
              Text("Product List Placeholder",
                  style: context.theme.textTheme.titleMedium),
              const SizedBox(height: 24),

              // TODO: Implement Reviews Section
              Text(LocaleKeys.vendor_detail_reviews_title.tr(),
                  style: context
                      .theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 16),
              Text("Reviews Placeholder",
                  style: context.theme.textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
