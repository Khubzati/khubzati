import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantHomeHeader extends StatelessWidget {
  const RestaurantHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Notification bell
          Positioned(
            top: 16.h,
            right: 16.w,
            child: IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24.sp,
              ),
              onPressed: () {
                context.router.push(const NotificationRoute());
              },
            ),
          ),
          // Welcome content
          Positioned(
            left: 20.w,
            right: 20.w,
            top: 60.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.app_restaurant_owner_home_welcome_title.tr(),
                  style: AppTextStyles.font32TextW700.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  LocaleKeys.app_restaurant_owner_home_welcome_subtitle.tr(),
                  style: AppTextStyles.font16TextW500.copyWith(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'عمان، الصويفية',
                      style: AppTextStyles.font16TextW500.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
