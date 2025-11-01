import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../routes/app_router.dart';
import '../theme/styles/app_colors.dart';
import '../../gen/translations/locale_keys.g.dart';
import 'global_navigation_wrapper.dart';

class NavItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  NavItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class SharedBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final bool showCenterButton;
  final Widget? centerButtonIcon;
  final VoidCallback? onCenterButtonTap;
  final double? centerButtonSize;
  final Color? centerButtonColor;
  final Color? centerButtonBorderColor;

  const SharedBottomNavbar({
    super.key,
    required this.currentIndex,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showCenterButton = true,
    this.centerButtonIcon,
    this.onCenterButtonTap,
    this.centerButtonSize,
    this.centerButtonColor,
    this.centerButtonBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Bottom navigation bar container
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.pageBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 18,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildNavItems(context),
            ),
          ),
        ),

        // Center button (if enabled)
        if (showCenterButton)
          Positioned(
            top: -40.h,
            child: GestureDetector(
              onTap: () {
                print('🔍 Center button tapped - calling callback');
                // Add haptic feedback for better user experience
                HapticFeedback.lightImpact();
                onCenterButtonTap?.call();
                print('🔍 Center button callback completed');
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: centerButtonSize ?? 70.w,
                height: centerButtonSize ?? 70.h,
                decoration: BoxDecoration(
                  color: centerButtonColor ?? AppColors.pageBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        centerButtonBorderColor ?? AppColors.primaryBurntOrange,
                    width: 2.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Center(
                  child: centerButtonIcon ??
                      Icon(
                        Icons.add,
                        color: AppColors.primaryBurntOrange,
                        size: 35.sp,
                      ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final List<Widget> navItems = [];
    const int middleIndex = 2; // Fixed middle index for 4 items

    // Define navigation items directly here to avoid context capture issues
    final List<Map<String, dynamic>> navData = [
      {
        'icon': Icons.home,
        'label': LocaleKeys.app_navigation_home.tr(),
        'route': MainNavigationRoute(initialIndex: 0),
        'pageIndex': 0, // Home page index in PageView
      },
      {
        'icon': Icons.inventory_2_outlined,
        'label': LocaleKeys.app_navigation_orders.tr(),
        'route': MainNavigationRoute(initialIndex: 1),
        'pageIndex': 1, // Inventory page index in PageView
      },
      {
        'icon': Icons.history,
        'label': LocaleKeys.app_history_title.tr(),
        'route': MainNavigationRoute(initialIndex: 2),
        'pageIndex': 2, // History page index in PageView
      },
      {
        'icon': Icons.person,
        'label': LocaleKeys.app_navigation_profile.tr(),
        'route': MainNavigationRoute(initialIndex: 3),
        'pageIndex': 3, // Profile page index in PageView
      },
    ];

    for (int i = 0; i < navData.length; i++) {
      // Add the nav item
      navItems.add(
        GestureDetector(
          onTap: () {
            if (context.mounted) {
              final pageIndex = navData[i]['pageIndex'] as int;
              final currentRouteName = context.router.current.name;

              // Check if we're already in the main navigation context
              if (currentRouteName == 'MainNavigationRoute') {
                // If we're in the main navigation, find the GlobalNavigationWrapper and switch pages
                final globalNavWrapper = context
                    .findAncestorStateOfType<GlobalNavigationWrapperState>();
                if (globalNavWrapper != null) {
                  print(
                      '  Action: Switching within main navigation to index $pageIndex');
                  globalNavWrapper.onItemTap(pageIndex);
                } else {
                  print('  Error: GlobalNavigationWrapper not found!');
                }
              } else {
                // For standalone screens (like inventory), navigate back to main navigation
                print(
                    '  Action: Navigating to MainNavigationRoute with initialIndex: $pageIndex');
                context.router
                    .replaceAll([MainNavigationRoute(initialIndex: pageIndex)]);
              }
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                navData[i]['icon'] as IconData,
                color: i == currentIndex
                    ? selectedItemColor ?? AppColors.primaryBurntOrange
                    : unselectedItemColor ??
                        AppColors.primaryBurntOrange.withOpacity(0.7),
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text(
                navData[i]['label'] as String,
                style: TextStyle(
                  color: i == currentIndex
                      ? selectedItemColor ?? AppColors.primaryBurntOrange
                      : unselectedItemColor ??
                          AppColors.primaryBurntOrange.withOpacity(0.7),
                  fontSize: 12.sp,
                  fontWeight:
                      i == currentIndex ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );

      // Add a spacer in the middle for the center button
      if (showCenterButton && i == middleIndex - 1) {
        navItems.add(SizedBox(width: 70.w));
      }
    }

    return navItems;
  }
}
