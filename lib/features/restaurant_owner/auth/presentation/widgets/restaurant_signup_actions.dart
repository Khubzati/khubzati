import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantSignupActions extends StatelessWidget {
  final VoidCallback onSubmit;
  final bool isLoading;

  const RestaurantSignupActions({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: LocaleKeys.app_restaurant_owner_auth_next.tr(),
          onPressed: isLoading ? null : onSubmit,
          isLoading: isLoading,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.app_restaurant_owner_auth_already_have_account.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => context.router.popAndPush(const LoginRoute()),
              child: Text(
                LocaleKeys.app_restaurant_owner_auth_login.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
