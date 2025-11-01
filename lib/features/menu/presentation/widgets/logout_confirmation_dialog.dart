import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

/// A reusable logout confirmation dialog widget
/// Following clean architecture and responsive design principles
class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const LogoutConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      backgroundColor: AppColors.creamColor,
      title: Text(
        LocaleKeys.app_general_logout.tr(),
        style: AppTextStyles.font20textDarkBrownbold,
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Are you sure you want to logout?',
        style: AppTextStyles.font14TextW400OP8,
        textAlign: TextAlign.center,
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 12.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: BorderSide(
                color: AppColors.textDarkBrown.withOpacity(0.3),
                width: 1.w,
              ),
            ),
          ),
          child: Text(
            LocaleKeys.app_common_cancel.tr(),
            style: AppTextStyles.font14TextW400OP8.copyWith(
              color: AppColors.textDarkBrown,
            ),
          ),
        ),
        8.horizontalSpace,
        // Logout Button
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 12.h,
            ),
            backgroundColor: AppColors.primaryBurntOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            LocaleKeys.app_general_logout.tr(),
            style: AppTextStyles.font14TextW400OP8.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 20.h,
      ),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
    );
  }

  /// Static method to show the logout confirmation dialog
  static Future<bool?> show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LogoutConfirmationDialog(
        onConfirm: () {
          Navigator.of(context).pop(true);
          onConfirm();
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
