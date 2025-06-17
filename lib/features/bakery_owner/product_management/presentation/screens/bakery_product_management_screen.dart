import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement BakeryProductManagementBloc for state management and API calls
// TODO: Implement UI for Listing Products (with edit/delete options)
// TODO: Implement navigation to Add/Edit Product Screen

class BakeryProductManagementScreen extends StatelessWidget {
  static const String routeName = '/bakery-owner-product-management';

  const BakeryProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch products using BakeryProductManagementBloc
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.bakery_owner_product_management_title.tr()), // Assuming this key exists
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: LocaleKeys.bakery_owner_product_management_add_product_button.tr(),
            onPressed: () {
              // TODO: Navigate to AddProductScreen
              print("Add Product Tapped");
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // TODO: Replace with actual product list or empty state message
          child: ListView.builder(
            itemCount: 4, // Placeholder count
            itemBuilder: (context, index) {
              // Replace with actual ProductListItemWidget and data
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.fastfood_outlined, size: 40, color: context.colorScheme.primary),
                  title: Text("${LocaleKeys.bakery_owner_product_management_product_name_placeholder.tr()} ${index + 1}"),
                  subtitle: Text("${LocaleKeys.bakery_owner_product_management_product_price_placeholder.tr()}: \SAR ${10 + index * 2}.00"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit_outlined, color: context.colorScheme.secondary), onPressed: () { /* TODO: Navigate to EditProductScreen */ }),
                      IconButton(icon: Icon(Icons.delete_outline, color: context.colorScheme.error), onPressed: () { /* TODO: Show delete confirmation */ }),
                    ],
                  ),
                  onTap: () {
                    // TODO: Navigate to view product details (if applicable) or edit screen
                    print("Tapped on Product ${index + 1}");
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

