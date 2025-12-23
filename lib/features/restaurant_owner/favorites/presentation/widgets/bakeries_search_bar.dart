import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class BakeriesSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;

  const BakeriesSearchBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.textDarkBrown.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: AppColors.textDarkBrown.withOpacity(0.5),
            size: 20.sp,
          ),
          12.horizontalSpace,
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: LocaleKeys.app_search_hint.tr(),
                hintStyle: AppTextStyles.font14TextW400OP8,
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.search,
                  color: AppColors.textDarkBrown.withOpacity(0.5),
                  size: 20.sp,
                ),
              ),
              style: AppTextStyles.font15TextW400,
            ),
          ),
        ],
      ),
    );
  }
}

