import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/features/restaurant_owner/cart/application/cubits/cart_cubit.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class ClearCartDialog extends StatelessWidget {
  const ClearCartDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) => const ClearCartDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        LocaleKeys.app_restaurant_owner_cart_clear_confirmation_title.tr(),
        style: AppTextStyles.font20textDarkBrownbold.copyWith(
          fontSize: 20.sp,
        ),
      ),
      content: Text(
        LocaleKeys.app_restaurant_owner_cart_clear_confirmation_message.tr(),
        style: AppTextStyles.font15TextW400.copyWith(
          fontSize: 15.sp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            LocaleKeys.app_restaurant_owner_cart_cancel.tr(),
            style: AppTextStyles.font16PrimaryBold.copyWith(
              fontSize: 16.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _handleClearCart(context),
          child: Text(
            LocaleKeys.app_restaurant_owner_cart_clear.tr(),
            style: AppTextStyles.font16PrimaryBold.copyWith(
              fontSize: 16.sp,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  void _handleClearCart(BuildContext context) {
    context.read<CartCubit>().clearCart();
    Navigator.of(context).pop();
  }
}
