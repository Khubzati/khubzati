import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement CheckoutBloc for state management (address selection, payment method, order summary, place order)
// TODO: Implement UI for Delivery Address, Payment Method, Order Summary sections
// TODO: Implement navigation to OrderConfirmationScreen or handle order placement result

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // TODO: Add state variables for selected address, payment method, etc.
  String? _selectedAddressId;
  String? _selectedPaymentMethod;

  void _placeOrder() {
    // TODO: Validate selections (address, payment)
    // TODO: Call CheckoutBloc to place the order
    print('Placing order with Address ID: $_selectedAddressId, Payment Method: $_selectedPaymentMethod');
    // Placeholder for navigation or showing success/error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.checkout_title.tr()), // Assuming this key exists
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Section 1: Delivery Address
              Text(LocaleKeys.checkout_delivery_address_title.tr(), style: context.theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 8),
              // TODO: Implement Address Selection UI (e.g., dropdown, list, or a dedicated widget)
              // Placeholder for address selection
              Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(_selectedAddressId ?? LocaleKeys.checkout_select_address_prompt.tr()),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    // TODO: Navigate to Address Selection/Management Screen or show a dialog
                    print('Select Address Tapped');
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Section 2: Payment Method
              Text(LocaleKeys.checkout_payment_method_title.tr(), style: context.theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 8),
              // TODO: Implement Payment Method Selection UI (e.g., radio buttons, list)
              // Placeholder for payment method selection
              Card(
                child: ListTile(
                  leading: const Icon(Icons.payment_outlined),
                  title: Text(_selectedPaymentMethod ?? LocaleKeys.checkout_select_payment_method_prompt.tr()),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    // TODO: Navigate to Payment Method Selection Screen or show a dialog
                    print('Select Payment Method Tapped');
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Section 3: Order Summary
              Text(LocaleKeys.checkout_order_summary_title.tr(), style: context.theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 8),
              // TODO: Implement Order Summary UI (list of items, subtotal, delivery fee, total)
              // Placeholder for order summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(LocaleKeys.cart_subtotal_label.tr()), Text("\SAR 20.00")]),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(LocaleKeys.checkout_delivery_fee_label.tr()), Text("\SAR 5.00")]),
                      const Divider(height: 24),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(LocaleKeys.cart_total_label.tr(), style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)), Text("\SAR 25.00", style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary))]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Place Order Button
              AppElevatedButton(
                text: LocaleKeys.checkout_place_order_button.tr(), // Assuming this key exists
                onPressed: _placeOrder,
                // TODO: Disable button if address/payment not selected or cart is empty
              ),
            ],
          ),
        ),
      ),
    );
  }
}

