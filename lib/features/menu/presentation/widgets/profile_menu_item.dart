import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';

/// Reusable profile menu item widget
/// Following clean architecture and responsive design
class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.textDarkBrown).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.textDarkBrown,
                size: 20.sp,
              ),
            ),
            16.horizontalSpace,
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.font16textDarkBrownBold.copyWith(
                  color: textColor ?? AppColors.textDarkBrown,
                ),
              ),
            ),
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.textDarkBrown.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
