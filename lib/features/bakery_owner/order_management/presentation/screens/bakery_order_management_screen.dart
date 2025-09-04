import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
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
        title: Text(LocaleKeys.app_bakery_owner_order_management_title.tr()),
        centerTitle: true,
        // TODO: Add any filter/sort options if required by Figma
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
                            .app_bakery_owner_order_management_order_id_placeholder
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

              // TODO: Implement Orders List (ListView.builder with OrderCard)
              // Placeholder for orders list
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Replace with actual orders count
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(
                            "${LocaleKeys.app_bakery_owner_order_management_customer_name_placeholder.tr()}: Customer ${index + 1}"),
                        subtitle: Text(
                            "${LocaleKeys.app_bakery_owner_order_management_order_status_placeholder.tr()}: Pending"),
                        trailing: Text("\SAR ${100 + (index * 25)}.00"),
                        onTap: () {
                          // TODO: Navigate to order details
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
