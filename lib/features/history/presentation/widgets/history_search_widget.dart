import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../gen/translations/locale_keys.g.dart';

class HistorySearchWidget extends StatelessWidget {
  final TextEditingController searchController;

  const HistorySearchWidget({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: AppColors.textDarkBrown),
        decoration: InputDecoration(
          hintText: LocaleKeys.app_history_search_placeholder.tr(),
          hintStyle: AppTextStyles.font14TextW400OP8.copyWith(
            color: AppColors.textDarkBrown.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textDarkBrown.withOpacity(0.6),
            size: 20.sp,
          ),
          suffixIcon: Icon(
            Icons.tune,
            color: AppColors.textDarkBrown.withOpacity(0.6),
            size: 20.sp,
          ),
          filled: true,
          fillColor: AppColors.secondaryLightCream,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.primaryBurntOrange.withOpacity(0.3),
              width: 1.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.primaryBurntOrange.withOpacity(0.3),
              width: 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.primaryBurntOrange,
              width: 2.w,
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }
}
