import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement OrderHistoryBloc for state management and API calls to fetch orders
// TODO: Implement OrderHistoryItem widget and ListView.builder to display past orders
// TODO: Implement navigation to OrderDetailScreen

class OrderHistoryScreen extends StatelessWidget {
  static const String routeName = '/order-history';

  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch order history using OrderHistoryBloc
    // bool hasOrders = false; // Placeholder, get from OrderHistoryBloc

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.order_history_title.tr()), // Assuming this key exists
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // TODO: Replace with actual order list or empty state message
          child: ListView.builder(
            itemCount: 3, // Placeholder count, replace with actual order count from OrderHistoryBloc
            itemBuilder: (context, index) {
              // Replace with actual OrderHistoryItemWidget and data
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.receipt_long_outlined, size: 40, color: context.colorScheme.primary),
                  title: Text("${LocaleKeys.order_history_order_id_placeholder.tr()} #12345${index + 1}"), // Placeholder
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${LocaleKeys.order_history_date_placeholder.tr()}: 2024-07-${20 + index}"), // Placeholder
                      Text("${LocaleKeys.order_history_status_placeholder.tr()}: Delivered", style: TextStyle(color: Colors.green[700])), // Placeholder
                      Text("${LocaleKeys.order_history_total_placeholder.tr()}: \SAR 75.00"), // Placeholder
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  isThreeLine: true,
                  onTap: () {
                    // TODO: Navigate to OrderDetailScreen with the specific order ID
                    print("Tapped on Order #12345${index + 1}");
                  },
                ),
              );
            },
          ),
          // child: hasOrders
          //     ? ListView.builder(
          //         itemCount: 0, // TODO: Get from OrderHistoryBloc
          //         itemBuilder: (context, index) {
          //           // TODO: Return OrderHistoryItemWidget
          //           return const SizedBox.shrink();
          //         },
          //       )
          //     : Center(
          //         child: Text(
          //           LocaleKeys.order_history_empty_message.tr(), // Assuming this key exists
          //           style: context.theme.textTheme.headlineSmall,
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
        ),
      ),
    );
  }
}

