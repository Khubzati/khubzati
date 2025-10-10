import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement RestaurantOrderManagementBloc for state management and API calls
// TODO: Implement UI for Listing Orders (with status updates, view details)
// TODO: Implement navigation to Order Detail Screen for restaurant vendors

class RestaurantOrderManagementScreen extends StatelessWidget {
  static const String routeName = '/restaurant-owner-order-management';

  const RestaurantOrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch orders using RestaurantOrderManagementBloc
    return Scaffold(
      appBar: AppBar(
        title:
            Text(LocaleKeys.app_restaurant_owner_order_management_title.tr()),
        centerTitle: true,
        // TODO: Add any filter/sort options if required by Figma
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // TODO: Replace with actual order list or empty state message
          child: ListView.builder(
            itemCount: 4, // Placeholder count
            itemBuilder: (context, index) {
              // Replace with actual OrderListItemWidget for restaurant vendors and data
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.dinner_dining_outlined,
                      size: 40, color: context.colorScheme.secondary),
                  title: Text(
                      "${LocaleKeys.app_restaurant_owner_order_management_order_id_placeholder.tr()} #${4000 + index}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${LocaleKeys.app_restaurant_owner_order_management_customer_name_placeholder.tr()}: Customer Name ${index + 1}"),
                      Text(
                          "${LocaleKeys.app_restaurant_owner_order_management_order_status_placeholder.tr()}: Accepted",
                          style: TextStyle(color: Colors.blue[700])),
                    ],
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  isThreeLine: true,
                  onTap: () {
                    // TODO: Navigate to VendorOrderDetailScreen with the specific order ID for restaurant
                    print("Tapped on Order #${4000 + index}");
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
