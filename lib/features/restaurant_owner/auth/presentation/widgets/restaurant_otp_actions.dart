import 'package:flutter/material.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantOtpActions extends StatelessWidget {
  final VoidCallback onResendOtp;
  final VoidCallback onChangePhone;
  final VoidCallback onVerify;
  final bool isLoading;

  const RestaurantOtpActions({
    super.key,
    required this.onResendOtp,
    required this.onChangePhone,
    required this.onVerify,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onResendOtp,
              child: Text(
                LocaleKeys.app_restaurant_owner_auth_resend_code.tr(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: onChangePhone,
              child: Text(
                LocaleKeys.app_restaurant_owner_auth_change_phone.tr(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        AppButton(
          text: LocaleKeys.app_restaurant_owner_auth_verify.tr(),
          onPressed: isLoading ? null : onVerify,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
