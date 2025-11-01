import 'package:flutter/material.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantOtpHeader extends StatelessWidget {
  final String phoneNumber;

  const RestaurantOtpHeader({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.app_restaurant_owner_auth_verify_phone_title.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text:
                LocaleKeys.app_restaurant_owner_auth_verify_phone_subtitle.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
            children: [
              TextSpan(
                text: ' $phoneNumber',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
