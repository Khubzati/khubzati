import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';
import '../../gen/translations/locale_keys.g.dart';

class HomepageHeader extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onNotificationPressed;

  const HomepageHeader({
    super.key,
    this.title,
    this.actions,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? context.tr(LocaleKeys.app_userTypeSelection_WelcomeText),
            style: AppTextStyles.font24TextW700,
          ),
          Row(
            children: [
              if (actions != null) ...actions!,
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.pageBackground,
                onPressed: onNotificationPressed ?? () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
