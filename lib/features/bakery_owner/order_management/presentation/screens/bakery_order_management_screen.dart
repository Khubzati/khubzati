import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement BakeryOrderManagementBloc for state management and API calls
// TODO: Implement UI for Listing Orders (with status updates, view details)
// TODO: Implement navigation to Order Detail Screen for vendors

class BakeryOrderManagementScreen extends StatelessWidget {
  static const String routeName = '/bakery-owner-order-management';

  const BakeryOrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch orders using BakeryOrderManagementBloc
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.bakery_owner_order_management_title.tr()), // Assuming this key exists
        centerTitle: true,
        // TODO: Add any filter/sort options if required by Figma
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // TODO: Replace with actual order list or empty state message
          child: ListView.builder(
            itemCount: 5, // Placeholder count
            itemBuilder: (context, index) {
              // Replace with actual OrderListItemWidget for vendors and data
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.receipt_long_outlined, size: 40, color: context.colorScheme.secondary),
                  title: Text("${LocaleKeys.bakery_owner_order_management_order_id_placeholder.tr()} #${2000 + index}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${LocaleKeys.bakery_owner_order_management_customer_name_placeholder.tr()}: Customer Name ${index + 1}"),
                      Text("${LocaleKeys.bakery_owner_order_management_order_status_placeholder.tr()}: Preparing", style: TextStyle(color: Colors.orange[700])),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  isThreeLine: true,
                  onTap: () {
                    // TODO: Navigate to VendorOrderDetailScreen with the specific order ID
                    print("Tapped on Order #${2000 + index}");
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

