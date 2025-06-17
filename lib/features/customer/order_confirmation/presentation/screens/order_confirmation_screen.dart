import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Potentially pass Order ID or details to this screen
// TODO: Implement navigation to Home Screen or Order History

class OrderConfirmationScreen extends StatelessWidget {
  static const String routeName = '/order-confirmation';
  // final String orderId; // Optional: if you want to display order specific info

  const OrderConfirmationScreen({super.key /*, required this.orderId */ });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.order_confirmation_title.tr()), // Assuming this key exists
        centerTitle: true,
        automaticallyImplyLeading: false, // Typically no back button on confirmation
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TODO: Add a success icon (e.g., Lottie animation or large Icon)
              Icon(
                Icons.check_circle_outline_rounded,
                size: 100,
                color: context.colorScheme.primary, // Or Colors.green
              ),
              const SizedBox(height: 32),
              Text(
                LocaleKeys.order_confirmation_heading.tr(), // e.g., "Order Placed Successfully!"
                style: context.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.order_confirmation_subheading.tr(), // e.g., "Thank you for your order. You can track its status in your order history."
                style: context.theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              // TODO: Optionally display Order ID or a brief summary if available
              // if (orderId.isNotEmpty) ...[
              //   const SizedBox(height: 16),
              //   Text(
              //     "${LocaleKeys.order_confirmation_order_id_label.tr()}: $orderId",
              //     style: context.theme.textTheme.bodyLarge,
              //     textAlign: TextAlign.center,
              //   ),
              // ],
              const SizedBox(height: 48),
              AppElevatedButton(
                text: LocaleKeys.order_confirmation_track_order_button.tr(), // "Track Your Order"
                onPressed: () {
                  // TODO: Navigate to Order History Screen
                  print("Track Order Tapped");
                  // Example: Navigator.of(context).pushNamedAndRemoveUntil(OrderHistoryScreen.routeName, (route) => false);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to Home Screen
                  print("Back to Home Tapped");
                  // Example: Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
                },
                child: Text(LocaleKeys.order_confirmation_back_to_home_button.tr()), // "Back to Home"
              ),
            ],
          ),
        ),
      ),
    );
  }
}

