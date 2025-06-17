import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement CartBloc for state management (add, remove, update quantity, calculate total)
// TODO: Implement CartItem widget and ListView.builder to display cart items
// TODO: Implement navigation to Checkout screen

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch cart items using CartBloc
    // bool isCartEmpty = true; // Placeholder, get from CartBloc

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.cart_title.tr()), // Assuming this key exists
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TODO: Replace with actual cart items list or empty cart message
              Expanded(
                child: ListView.builder(
                  itemCount: 2, // Placeholder count, replace with actual cart item count from CartBloc
                  itemBuilder: (context, index) {
                    // Replace with actual CartItemWidget and data
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Placeholder for Product Image
                            Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              margin: const EdgeInsetsDirectional.only(end: 12.0),
                              child: Icon(Icons.image_outlined, color: Colors.grey[600]),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${LocaleKeys.cart_item_name_placeholder.tr()} ${index + 1}", style: context.theme.textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text("\SAR 10.00", style: context.theme.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary)), // Placeholder price
                                ],
                              ),
                            ),
                            // Placeholder for Quantity Adjustment & Remove Button
                            Row(
                              children: [
                                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () { /* TODO: Decrement quantity */ }),
                                Text("1", style: context.theme.textTheme.titleMedium), // Placeholder quantity
                                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () { /* TODO: Increment quantity */ }),
                                IconButton(icon: Icon(Icons.delete_outline, color: context.colorScheme.error), onPressed: () { /* TODO: Remove item */ }),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // child: isCartEmpty
                //     ? Center(child: Text(LocaleKeys.cart_empty_message.tr(), style: context.theme.textTheme.headlineSmall))
                //     : ListView.builder(
                //         itemCount: 0, // TODO: Get from CartBloc
                //         itemBuilder: (context, index) {
                //           // TODO: Return CartItemWidget
                //           return const SizedBox.shrink();
                //         },
                //       ),
              ),
              const SizedBox(height: 16),
              // TODO: Implement Order Summary (Subtotal, Delivery, Total)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocaleKeys.cart_subtotal_label.tr(), style: context.theme.textTheme.titleMedium),
                    Text("\SAR 20.00", style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)), // Placeholder
                  ],
                ),
              ),
              // Add more for delivery, total etc.
              const Divider(),
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocaleKeys.cart_total_label.tr(), style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text("\SAR 20.00", style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary)), // Placeholder
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppElevatedButton(
                text: LocaleKeys.cart_proceed_to_checkout_button.tr(),
                onPressed: () {
                  // TODO: Navigate to CheckoutScreen
                  print("Proceed to Checkout Tapped");
                },
                // TODO: Disable button if cart is empty
              ),
            ],
          ),
        ),
      ),
    );
  }
}

