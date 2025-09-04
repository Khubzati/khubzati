import 'package:flutter/material.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// TODO: Potentially pass Order ID or details to this screen
// TODO: Implement navigation to Home Screen or Order History

class OrderConfirmationScreen extends StatelessWidget {
  static const String routeName = '/order-confirmation';
  // final String orderId; // Optional: if you want to display order specific info

  const OrderConfirmationScreen({super.key /*, required this.orderId */});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.app_order_confirmation_title.tr()),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                LocaleKeys.app_order_confirmation_heading.tr(),
                style: context.theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.app_order_confirmation_subheading.tr(),
                style: context.theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppElevatedButton(
                child: Text(
                    LocaleKeys.app_order_confirmation_track_order_button.tr()),
                onPressed: () {
                  // TODO: Navigate to Order History Screen
                  print("Track Order Tapped");
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to Home Screen
                  print("Back to Home Tapped");
                },
                child: Text(
                    LocaleKeys.app_order_confirmation_back_to_home_button.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
