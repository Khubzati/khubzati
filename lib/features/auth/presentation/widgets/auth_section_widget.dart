import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/app_elevated_button.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import 'auth_toggle_widget.dart';

class AuthSectionWidget extends StatelessWidget {
  final VoidCallback? onAuthPressed;

  const AuthSectionWidget({
    super.key,
    this.onAuthPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          64.verticalSpace,
          // Unified authentication button
          AppElevatedButton(
            backgroundColor: AppColors.primaryBurntOrange.withOpacity(0.9),
            onPressed: onAuthPressed,
            child: Text(
              LocaleKeys.app_auth_login_button.tr(),
              style: AppTextStyles.font16TextW500,
            ),
          ),
          24.verticalSpace,
          // Create account link
          const AuthToggleWidget(),
          40.verticalSpace,
        ],
      ),
    );
  }
}
