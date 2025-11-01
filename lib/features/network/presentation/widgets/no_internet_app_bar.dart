import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class NoInternetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoInternetAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocaleKeys.app_no_internet_back.tr(),
                style: AppTextStyles.font16BurntOrange500),
            4.horizontalSpace,
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.primaryBurntOrange,
            ),
          ],
        ),
        onPressed: () => context.router.maybePop(),
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
