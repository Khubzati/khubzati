import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';

/// Reusable settings item widget with optional toggle switch
/// Following clean architecture and responsive design
class SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool? showToggle;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;
  final bool showDivider;

  const SettingsItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.showToggle,
    this.toggleValue,
    this.onToggleChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
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
                    color:
                        (iconColor ?? AppColors.textDarkBrown).withOpacity(0.1),
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
                // Toggle or Arrow
                if (showToggle == true && toggleValue != null)
                  Switch(
                    value: toggleValue!,
                    onChanged: onToggleChanged,
                  )
                else if (showToggle != true)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: AppColors.textDarkBrown.withOpacity(0.5),
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1.h,
            color: AppColors.textDarkBrown.withOpacity(0.2),
            thickness: 1,
          ),
      ],
    );
  }
}
