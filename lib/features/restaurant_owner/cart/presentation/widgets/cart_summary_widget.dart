import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_shadows.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class CartSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final VoidCallback onCheckout;
  final bool isLoading;

  const CartSummaryWidget({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.onCheckout,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [AppShadows.blur50BlackOP10OffsetDy4.first],
        color: AppColors.secondaryLightCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order Summary
              _buildSummaryRow(
                context,
                LocaleKeys.app_restaurant_owner_cart_subtotal.tr(),
                _formatPrice(subtotal),
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                context,
                LocaleKeys.app_restaurant_owner_cart_delivery_fee.tr(),
                _formatPrice(deliveryFee),
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                context,
                LocaleKeys.app_restaurant_owner_cart_tax.tr(),
                _formatPrice(tax),
              ),
              SizedBox(height: 12.h),
              Divider(
                color: AppColors.outline,
                thickness: 1,
              ),
              SizedBox(height: 12.h),
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.app_restaurant_owner_cart_total.tr(),
                    style: AppTextStyles.font20textDarkBrownbold,
                  ),
                  Text(
                    _formatPrice(total),
                    style: AppTextStyles.font20PrimaryBurntOrange,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Checkout Button
              AppButton(
                text: LocaleKeys.app_restaurant_owner_cart_checkout.tr(),
                onPressed: isLoading ? null : onCheckout,
                type: AppButtonType.primary,
                size: AppButtonSize.large,
                isFullWidth: true,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.font15TextW400.copyWith(
            fontSize: 14.sp,
            color: AppColors.textDarkBrown.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.font15TextW400.copyWith(
            fontSize: 14.sp,
            color: AppColors.textDarkBrown,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ${LocaleKeys.app_restaurant_owner_cart_currency.tr()}';
  }
}
