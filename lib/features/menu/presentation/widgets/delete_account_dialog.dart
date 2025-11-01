import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared_bottom_sheet.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

/// Delete account confirmation bottom sheet widget
/// Using SharedBottomSheet for consistency with the codebase
/// Matches the Figma design with SVG illustration
class DeleteAccountDialog {
  /// Static method to show the delete account confirmation bottom sheet
  static Future<bool?> show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    return SharedBottomSheet.show<bool>(
      context: context,
      svgAssetPath: Assets.images.deleteAccount,
      backgroundColor: AppColors.creamColor,
      borderRadius: 25,
      showGrabHandle: false,
      showCloseButton: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            LocaleKeys.app_settings_delete_account_confirmation.tr(),
            style: AppTextStyles.font24Textbold,
            textAlign: TextAlign.center,
          ),
          20.verticalSpace,
          // Warning message
          Text(
            LocaleKeys.app_settings_delete_account_warning.tr(),
            style: AppTextStyles.font16TextW500.copyWith(
              color: AppColors.textDarkBrown,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      footer: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 40.h),
        child: Row(
          children: [
            // Cancel Button (Filled)
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: AppColors.primaryBurntOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  LocaleKeys.app_common_cancel.tr(),
                  style: AppTextStyles.font16textDarkBrownBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            16.horizontalSpace,
            // Delete Account Button (Outlined)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  side: BorderSide(
                    color: AppColors.textDarkBrown.withOpacity(0.3),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  LocaleKeys.app_settings_delete_account.tr(),
                  style: AppTextStyles.font16textDarkBrownBold.copyWith(
                    color: AppColors.textDarkBrown,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
