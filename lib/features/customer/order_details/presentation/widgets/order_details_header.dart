import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/styles/app_colors.dart';
import '../../../../../core/theme/styles/app_text_style.dart';
import '../../../../../core/widgets/shared_app_background.dart';

class OrderDetailsHeader extends StatelessWidget {
  final String orderId;

  const OrderDetailsHeader({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 125.h,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: SharedAppBackground(
              fit: BoxFit.cover,
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Title and back arrow
          Positioned(
            left: 216.w,
            top: 71.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 24.sp,
                    color: AppColors.secondaryLightCream,
                  ),
                ),
                Text(
                  "app.order_details.title".tr(),
                  style: AppTextStyles.font16textDarkBrownBold.copyWith(
                    color: AppColors.secondaryLightCream,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.w,
            top: 71.h,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.more_vert_sharp,
                size: 24.sp,
                color: AppColors.secondaryLightCream,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
