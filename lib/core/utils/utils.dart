// ignore_for_file: depend_on_referenced_packages

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khubzati/core/routes/app_router.dart';

import '../constants/constants.dart';
import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';
import '../widgets/app_elevated_button.dart';

bool isEmpty(String? value) => value == null || value.trim().isEmpty;
bool isName(String value) => AppRegex.name.hasMatch(value);
bool isEmail(String value) => AppRegex.email.hasMatch(value);
bool isPassword(String value) => AppRegex.password.hasMatch(value);
void showAppLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryBurntOrange,
      ),
    ),
  );
}

void showAppModalBottomSheet({
  required BuildContext context,
  required String title,
  required String subTitle,
  required String mainBtnLabel,
  required VoidCallback mainOnPressed,
  String? secBtnLabel,
  VoidCallback? secOnPressed,
  String? imagePath,
  TextStyle? titleStyle,
  bool isDismissible = false,
}) {
  showModalBottomSheet(
    useSafeArea: true,
    isDismissible: isDismissible,
    isScrollControlled: true,
    enableDrag: false,
    context: context,
    builder: (builder) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.w),
              topRight: Radius.circular(25.w),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              48.verticalSpace,
              if (imagePath != null) ...[
                SvgPicture.asset(imagePath),
                23.verticalSpace
              ],
              Text(
                context.tr(title),
                style: titleStyle ?? AppTextStyles.font32TextW700,
                textAlign: TextAlign.center,
              ),
              15.verticalSpace,
              Opacity(
                opacity: 0.7,
                child: Text(
                  context.tr(subTitle),
                  style: AppTextStyles.font24TextW400,
                  textAlign: TextAlign.center,
                ),
              ),
              23.verticalSpace,
              AppElevatedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                onPressed: mainOnPressed,
                child: Text(context.tr(mainBtnLabel)),
              ),
              if (secBtnLabel != null) ...[
                16.verticalSpace,
                AppElevatedButton(
                  elevation: 0,
                  onPressed: secOnPressed,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: const BorderSide(
                      color: Color(0xffF22D2D),
                    ),
                  ),
                  child: Text(
                    context.tr(secBtnLabel),
                    style: AppTextStyles.font15TextW400
                        .copyWith(color: const Color(0xffF22D2D)),
                  ),
                )
              ],
              43.verticalSpace
            ],
          ),
        ),
      );
    },
  );
}

void navigateToHomePage(BuildContext context) {
  context.router.replaceAll([const LoginRoute()], updateExistingRoutes: false);
}
