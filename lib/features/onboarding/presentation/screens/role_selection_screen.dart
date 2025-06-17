import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Create Cubit for state management if needed for role persistence or complex logic
@RoutePage()
class RoleSelectionScreen extends StatelessWidget {
  static const String routeName = '/role-selection';

  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.onboarding_select_role_title.tr()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                LocaleKeys.onboarding_select_role_heading
                    .tr(), // Assuming this key exists or will be added
                style: context.theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppElevatedButton(
                text:
                    LocaleKeys.roles_customer.tr(), // Assuming this key exists
                onPressed: () {
                  // TODO: Persist role as 'customer'
                  // TODO: Navigate to Customer App Flow (e.g., Login/Signup or Home)
                  print("Selected Role: Customer");
                },
              ),
              const SizedBox(height: 16),
              AppElevatedButton(
                text: LocaleKeys.roles_bakery_owner
                    .tr(), // Assuming this key exists
                onPressed: () {
                  // TODO: Persist role as 'bakery_owner'
                  // TODO: Navigate to Bakery Owner App Flow (e.g., Login/Signup or Dashboard)
                  print("Selected Role: Bakery Owner");
                },
              ),
              const SizedBox(height: 16),
              AppElevatedButton(
                child: LocaleKeys.roles_restaurant_owner
                    .tr(), // Assuming this key exists
                onPressed: () {
                  // TODO: Persist role as 'restaurant_owner'
                  // TODO: Navigate to Restaurant Owner App Flow (e.g., Login/Signup or Dashboard)
                  print("Selected Role: Restaurant Owner");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
