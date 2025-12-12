import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/features/restaurant_owner/cart/application/cubits/cart_cubit.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class CartErrorWidget extends StatelessWidget {
  final String message;

  const CartErrorWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.creamColor,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: AppColors.error,
              ),
              SizedBox(height: 16.h),
              Text(
                message,
                style: AppTextStyles.font16textDarkBrownBold.copyWith(
                  color: AppColors.error,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              AppButton(
                text: LocaleKeys.app_restaurant_owner_cart_retry.tr(),
                onPressed: () => _handleRetry(context),
                type: AppButtonType.primary,
                size: AppButtonSize.medium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRetry(BuildContext context) {
    context.read<CartCubit>().loadCart();
  }
}
