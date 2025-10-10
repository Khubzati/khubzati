// lib/core/widgets/bottom_sheet_widget.dart
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../gen/assets.gen.dart';
import '../../gen/translations/locale_keys.g.dart';
import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';
import 'app_elevated_button.dart';
import '../../core/routes/app_router.dart';

class BottomSheetWidget extends StatelessWidget {
  final String? svgAssetPath;
  final String? title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const BottomSheetWidget({
    super.key,
    this.svgAssetPath,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.pageBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.w),
              topRight: Radius.circular(25.w),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              130.verticalSpace, // Space for the SVG that will be positioned
              Text(
                title ??
                    context.tr(LocaleKeys.app_general_admin_succes_message),
                style: AppTextStyles.font32TextW700,
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              if (message != null) ...[
                Text(
                  message!,
                  style: AppTextStyles.font16TextW500,
                  textAlign: TextAlign.center,
                ),
                20.verticalSpace,
              ],
              if (message != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: AppElevatedButton(
                    onPressed: onButtonPressed ??
                        () {
                          // context.read<AuthCubit>().signout();
                          context.router.push(const LoginRoute());
                        },
                    child: Text(
                      buttonText ?? '',
                    ),
                  ),
                ),
                60.verticalSpace
              ] else
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                )
            ],
          ),
        ),
        Positioned(
          top: -100,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            svgAssetPath ?? Assets.images.successMessage,
          ),
        ),
      ],
    );
  }

  // Static method to show the bottom sheet with custom parameters
  static Future<void> show({
    required BuildContext context,
    String? svgAssetPath,
    String? title,
    String? message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetWidget(
        svgAssetPath: svgAssetPath,
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
      ),
    );
  }
}
