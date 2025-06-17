import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement RestaurantProductManagementBloc for state management and API calls
// TODO: Implement UI for Listing Menu Items (with edit/delete options)
// TODO: Implement navigation to Add/Edit Menu Item Screen

class RestaurantProductManagementScreen extends StatelessWidget {
  static const String routeName = '/restaurant-owner-product-management';

  const RestaurantProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch menu items using RestaurantProductManagementBloc
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.restaurant_owner_product_management_title.tr()), // Assuming this key exists
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: LocaleKeys.restaurant_owner_product_management_add_item_button.tr(),
            onPressed: () {
              // TODO: Navigate to AddMenuItemScreen
              print("Add Menu Item Tapped");
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // TODO: Replace with actual menu item list or empty state message
          child: ListView.builder(
            itemCount: 3, // Placeholder count
            itemBuilder: (context, index) {
              // Replace with actual MenuItemListItemWidget and data
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.ramen_dining_outlined, size: 40, color: context.colorScheme.primary),
                  title: Text("${LocaleKeys.restaurant_owner_product_management_item_name_placeholder.tr()} ${index + 1}"),
                  subtitle: Text("${LocaleKeys.restaurant_owner_product_management_item_price_placeholder.tr()}: \SAR ${25 + index * 5}.00"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit_outlined, color: context.colorScheme.secondary), onPressed: () { /* TODO: Navigate to EditMenuItemScreen */ }),
                      IconButton(icon: Icon(Icons.delete_outline, color: context.colorScheme.error), onPressed: () { /* TODO: Show delete confirmation */ }),
                    ],
                  ),
                  onTap: () {
                    // TODO: Navigate to view menu item details (if applicable) or edit screen
                    print("Tapped on Menu Item ${index + 1}");
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

