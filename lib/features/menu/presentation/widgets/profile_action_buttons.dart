import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileActionButtons extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;

  const ProfileActionButtons({
    super.key,
    required this.isEditing,
    required this.onEditPressed,
    required this.onSavePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          if (isEditing) ...[
            60.verticalSpace,
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: AppButton(
                text: LocaleKeys.app_inventory_saveChanges.tr(),
                onPressed: onSavePressed,
                backgroundColor: AppColors.primaryBurntOrange,
                textColor: Colors.white,
                borderRadius: 8.r,
              ),
            ),
            16.verticalSpace,
            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: AppButton(
                text: LocaleKeys.app_common_cancel.tr(),
                onPressed: onCancelPressed,
                backgroundColor: Colors.transparent,
                textColor: AppColors.primaryBurntOrange,
                borderRadius: 8.r,
              ),
            ),
          ] else ...[
            // Edit Button
            60.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: AppButton(
                text: LocaleKeys.app_profile_edit_info.tr(),
                onPressed: onEditPressed,
                backgroundColor: AppColors.primaryBurntOrange,
                textColor: Colors.white,
                borderRadius: 8.r,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
