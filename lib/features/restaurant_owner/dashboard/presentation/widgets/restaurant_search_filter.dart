import 'package:flutter/material.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';
import 'package:khubzati/core/widgets/app_text_field.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantSearchFilter extends StatelessWidget {
  final String searchQuery;
  final String selectedFilter;
  final Function(String) onSearchChanged;
  final Function(String) onFilterChanged;
  final VoidCallback onSearchPressed;

  const RestaurantSearchFilter({
    super.key,
    required this.searchQuery,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Filter button
          SizedBox(
            width: 50.w,
            height: 50.h,
            child: AppElevatedButton(
              onPressed: () => _showFilterBottomSheet(context),
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.tune,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Search field
          Expanded(
            child: SizedBox(
              height: 50.h,
              child: AppTextFormField(
                hintText: LocaleKeys
                    .app_restaurant_owner_home_search_placeholder
                    .tr(),
                onChanged: (value) => onSearchChanged(value ?? ''),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Search button
          SizedBox(
            width: 50.w,
            height: 50.h,
            child: AppButton(
              text: '',
              onPressed: onSearchPressed,
              backgroundColor: AppColors.primary,
              icon: Icons.search,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.app_restaurant_owner_home_filter.tr(),
              style: AppTextStyles.font20textDarkBrownbold,
            ),
            SizedBox(height: 20.h),
            _buildFilterOption(context, 'rating', 'التقييم العالي'),
            _buildFilterOption(context, 'fast_delivery', 'التوصيل السريع'),
            _buildFilterOption(context, 'favorites', 'المفضلة'),
            _buildFilterOption(context, '', 'الكل'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String value, String label) {
    final isSelected = selectedFilter == value;
    return ListTile(
      title: Text(
        label,
        style: AppTextStyles.font16textDarkBrownBold.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textDarkBrown,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: AppColors.primary,
            )
          : null,
      onTap: () {
        onFilterChanged(value);
        Navigator.pop(context);
      },
    );
  }
}
