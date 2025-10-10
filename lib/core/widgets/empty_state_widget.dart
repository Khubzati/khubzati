import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

import '../../gen/assets.gen.dart';
import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? description;
  final String? svgAssetPath;
  final IconData? icon;
  final Widget? actionButton;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.subtitle,
    this.description,
    this.svgAssetPath,
    this.icon,
    this.actionButton,
    this.iconSize,
    this.padding,
  });

  /// Factory constructor for no orders empty state
  factory EmptyStateWidget.noOrders({
    Key? key,
    Widget? actionButton,
  }) {
    return EmptyStateWidget(
      key: key,
      title: LocaleKeys.app_empty_state_no_orders_title.tr(),
      subtitle: LocaleKeys.app_empty_state_no_orders_subtitle.tr(),
      description: LocaleKeys.app_empty_state_no_orders_description.tr(),
      svgAssetPath: Assets.images.baker,
      iconSize: 120,
      actionButton: actionButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or SVG
            if (svgAssetPath != null)
              SvgPicture.asset(
                svgAssetPath!,
                width: iconSize ?? 80.w,
                height: iconSize ?? 80.w,
                colorFilter: ColorFilter.mode(
                  AppColors.textDarkBrown.withOpacity(0.3),
                  BlendMode.srcIn,
                ),
              )
            else if (icon != null)
              Icon(
                icon!,
                size: iconSize ?? 80.w,
                color: AppColors.textDarkBrown.withOpacity(0.3),
              ),

            SizedBox(height: 24.h),

            // Title
            if (title != null)
              Text(
                title!,
                style: AppTextStyles.font20TextW500.copyWith(
                  color: AppColors.textDarkBrown,
                ),
                textAlign: TextAlign.center,
              ),

            if (title != null) SizedBox(height: 8.h),

            // Subtitle
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppTextStyles.font16TextW500.copyWith(
                  color: AppColors.textDarkBrown.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

            if (subtitle != null) SizedBox(height: 12.h),

            // Description
            if (description != null)
              Text(
                description!,
                style: AppTextStyles.font14TextW400OP8.copyWith(
                  color: AppColors.textDarkBrown.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),

            if (description != null) SizedBox(height: 32.h),

            // Action Button
            if (actionButton != null) actionButton!,
          ],
        ),
      ),
    );
  }
}
