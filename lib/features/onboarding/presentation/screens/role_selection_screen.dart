import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// TODO: Create Cubit for state management if needed for role persistence or complex logic

@RoutePage()
class RoleSelectionScreen extends StatelessWidget {
  static const String routeName = '/role-selection';

  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.app_onboarding_select_role_title.tr()),
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
                LocaleKeys.app_onboarding_select_role_heading.tr(),
                style: context.theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppElevatedButton(
                child: Text(LocaleKeys.app_roles_customer.tr()),
                onPressed: () {
                  print("Selected Role: Customer");
                },
              ),
              const SizedBox(height: 16),
              AppElevatedButton(
                child: Text(LocaleKeys.app_roles_bakery_owner.tr()),
                onPressed: () {
                  print("Selected Role: Bakery Owner");
                },
              ),
              const SizedBox(height: 16),
              AppElevatedButton(
                child: Text(LocaleKeys.app_roles_restaurant_owner.tr()),
                onPressed: () {
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
