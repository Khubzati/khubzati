import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

/// Profile menu header widget showing bakery name and view profile link
/// Following clean architecture and responsive design
class ProfileMenuHeader extends StatelessWidget {
  final String bakeryName;

  const ProfileMenuHeader({
    super.key,
    required this.bakeryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Bakery Icon/Circle
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.creamColor,
              border: Border.all(
                color: AppColors.textDarkBrown.withOpacity(0.2),
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.store,
              color: AppColors.primaryBurntOrange,
              size: 30.sp,
            ),
          ),
          16.horizontalSpace,
          // Bakery Name and View Profile Link
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bakeryName,
                  style: AppTextStyles.font20textDarkBrownbold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                8.verticalSpace,
                GestureDetector(
                  onTap: () {
                    context.router.push(const ProfileRoute());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.app_profile_settings_edit_profile.tr(),
                        style: AppTextStyles.font14TextW400OP8.copyWith(
                          color: AppColors.primaryBurntOrange,
                        ),
                      ),
                      4.horizontalSpace,
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12.sp,
                        color: AppColors.primaryBurntOrange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
