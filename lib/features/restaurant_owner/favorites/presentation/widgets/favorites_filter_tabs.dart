import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class RestaurantOwnerFavoritesFilterTabs extends StatelessWidget {
  final String currentTab; // 'items' or 'bakeries'
  final ValueChanged<String> onTabChanged;

  const RestaurantOwnerFavoritesFilterTabs({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryLightCream,
        border: Border(
          bottom: BorderSide(
            color: AppColors.textDarkBrown.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            'items',
            LocaleKeys.app_restaurant_owner_favorites_items.tr(),
            currentTab == 'items',
          ),
          SizedBox(width: 8.w),
          _buildTab(
            context,
            'bakeries',
            LocaleKeys.app_restaurant_owner_favorites_bakeries.tr(),
            currentTab == 'bakeries',
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String tab,
    String label,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(tab),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBurntOrange.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16textDarkBrownBold.copyWith(
              color: isSelected
                  ? AppColors.primaryBurntOrange
                  : AppColors.textDarkBrown.withOpacity(0.6),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

