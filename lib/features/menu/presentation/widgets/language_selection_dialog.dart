import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared_bottom_sheet.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

/// Language selection bottom sheet widget
/// Using SharedBottomSheet for consistency with the codebase
class LanguageSelectionDialog {
  /// Static method to show the language selection bottom sheet
  static Future<void> show({
    required BuildContext context,
    required String currentLanguage,
    required Function(String) onLanguageSelected,
  }) {
    final supportedLanguages = [
      {'code': 'ar', 'name': 'العربية'},
      {'code': 'en', 'name': 'English'},
    ];

    return SharedBottomSheet.show(
      context: context,
      title: LocaleKeys.app_settings_language.tr(),
      backgroundColor: AppColors.creamColor,
      borderRadius: 25,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: supportedLanguages.map((language) {
          final isSelected = language['code'] == currentLanguage;
          return InkWell(
            onTap: () {
              Navigator.of(context).pop();
              onLanguageSelected(language['code']!);
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBurntOrange.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
                border: isSelected
                    ? Border.all(
                        color: AppColors.primaryBurntOrange,
                        width: 2.w,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      language['name']!,
                      style: AppTextStyles.font16textDarkBrownBold.copyWith(
                        color: isSelected
                            ? AppColors.primaryBurntOrange
                            : AppColors.textDarkBrown,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primaryBurntOrange,
                      size: 24.sp,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
