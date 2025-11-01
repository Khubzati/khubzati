import 'package:flutter/material.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantSignupHeader extends StatelessWidget {
  const RestaurantSignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.app_restaurant_owner_auth_welcome_title.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.app_restaurant_owner_auth_welcome_subtitle.tr(),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
