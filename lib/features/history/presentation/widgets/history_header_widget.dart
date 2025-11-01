import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/routes/app_router.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import '../../../../core/widgets/global_navigation_wrapper.dart';

class HistoryHeaderWidget extends StatelessWidget {
  const HistoryHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: () {
              // Find the GlobalNavigationWrapper and switch to homepage (index 0)
              final globalNavWrapper = context
                  .findAncestorStateOfType<GlobalNavigationWrapperState>();
              if (globalNavWrapper != null) {
                globalNavWrapper.onItemTap(0); // Switch to homepage
              } else {
                // Fallback: try to pop if there's a route to pop
                context.router.maybePop();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.sp,
              color: AppColors.secondaryLightCream,
            ),
          ),
          Text(
            LocaleKeys.app_history_title.tr(),
            style: AppTextStyles.font24TextW700,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.router.push(const NotificationRoute());
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.secondaryLightCream,
            ),
          ),
        ],
      ),
    );
  }
}
