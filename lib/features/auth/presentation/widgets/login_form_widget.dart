import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import 'phone_input_widget.dart';

class LoginFormWidget extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final TextEditingController phoneController;
  final ValueChanged<dynamic>? onPhoneChanged;

  const LoginFormWidget({
    super.key,
    required this.slideAnimation,
    required this.phoneController,
    this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Text(
              LocaleKeys.app_auth_login_subheading.tr(),
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textDarkBrown,
                letterSpacing: 0.5,
              ),
            ),
            8.verticalSpace,
            Text(
              LocaleKeys.app_auth_login_subheading.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textDarkBrown.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            32.verticalSpace,
            // Phone input with modern styling
            PhoneInputWidget(
              controller: phoneController,
              onChanged: onPhoneChanged,
            ),
          ],
        ),
      ),
    );
  }
}
