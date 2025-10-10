import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/styles/app_colors.dart';
import '../../theme/styles/app_text_style.dart';

class ProductInfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool alignRight;

  const ProductInfoColumn({
    super.key,
    required this.label,
    required this.value,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.5,
          child: Text(
            label,
            style: AppTextStyles.font12PrimaryBurntOrange.copyWith(
              color: AppColors.textDarkBrown,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
        4.verticalSpace,
        Text(
          value,
          style: AppTextStyles.font16textDarkBrownBold.copyWith(
            color: AppColors.textDarkBrown,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
