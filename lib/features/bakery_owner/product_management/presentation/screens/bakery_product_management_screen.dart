import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
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
        title: Text(LocaleKeys.app_bakery_owner_product_management_title.tr()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: LocaleKeys
                .app_bakery_owner_product_management_add_product_button
                .tr(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TODO: Implement Search Bar and Filter Options
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color: context.colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        LocaleKeys
                            .app_bakery_owner_product_management_product_name_placeholder
                            .tr(),
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // TODO: Implement Products List (ListView.builder with ProductCard)
              // Placeholder for products list
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Replace with actual products count
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: context.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        title: Text(
                            "${LocaleKeys.app_bakery_owner_product_management_product_name_placeholder.tr()}: Product ${index + 1}"),
                        subtitle: Text(
                            "${LocaleKeys.app_bakery_owner_product_management_product_price_placeholder.tr()}: \SAR ${20 + (index * 5)}.00"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: context.colorScheme.primary),
                              onPressed: () {
                                // TODO: Navigate to edit product
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: context.colorScheme.error),
                              onPressed: () {
                                // TODO: Show delete confirmation dialog
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // TODO: Navigate to product details
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
