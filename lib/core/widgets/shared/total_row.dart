import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/styles/app_colors.dart';
import '../../theme/styles/app_text_style.dart';

class TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showCurrency;
  final bool isTotal;

  const TotalRow({
    super.key,
    required this.label,
    required this.value,
    this.showCurrency = true,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Value
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCurrency) ...[
              Text(
                "app.order_details.currency".tr(),
                style: AppTextStyles.font12PrimaryBurntOrange.copyWith(
                  color: AppColors.textDarkBrown,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              4.horizontalSpace,
            ],
            Text(
              value,
              style: AppTextStyles.font16textDarkBrownBold.copyWith(
                color: AppColors.textDarkBrown,
                fontSize: isTotal ? 20.sp : 16.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),

        // Label
        Opacity(
          opacity: isTotal ? 1.0 : 0.5,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: AppTextStyles.font12PrimaryBurntOrange.copyWith(
              color: AppColors.textDarkBrown,
              fontSize: isTotal ? 16.sp : 12.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
