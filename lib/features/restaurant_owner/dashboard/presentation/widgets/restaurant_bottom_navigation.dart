import 'package:flutter/material.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const RestaurantBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                Icons.grid_view,
                LocaleKeys.app_restaurant_owner_home_menu.tr(),
                0,
              ),
              _buildNavItem(
                Icons.favorite_border,
                LocaleKeys.app_restaurant_owner_home_favorites.tr(),
                1,
              ),
              _buildNavItem(
                Icons.calendar_today,
                LocaleKeys.app_restaurant_owner_home_daily.tr(),
                2,
              ),
              _buildNavItem(
                Icons.shopping_cart,
                LocaleKeys.app_restaurant_owner_home_cart.tr(),
                3,
              ),
              _buildNavItem(
                Icons.home,
                LocaleKeys.app_restaurant_owner_home_home.tr(),
                4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.grey,
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.font12PrimaryBurntOrange.copyWith(
              color: isActive ? AppColors.primary : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
