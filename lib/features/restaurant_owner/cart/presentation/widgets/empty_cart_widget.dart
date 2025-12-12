import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onBrowseRestaurants;

  const EmptyCartWidget({
    super.key,
    this.onBrowseRestaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.creamColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 120.sp,
              color: AppColors.textDarkBrown.withOpacity(0.3),
            ),
            SizedBox(height: 24.h),
            Text(
              LocaleKeys.app_restaurant_owner_cart_empty_title.tr(),
              style: AppTextStyles.font24Textbold.copyWith(
                color: AppColors.textDarkBrown,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              LocaleKeys.app_restaurant_owner_cart_empty_subtitle.tr(),
              style: AppTextStyles.font14TextW400OP8.copyWith(
                color: AppColors.textDarkBrown.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            AppButton(
              text:
                  LocaleKeys.app_restaurant_owner_cart_browse_restaurants.tr(),
              onPressed: onBrowseRestaurants ?? () {},
              type: AppButtonType.primary,
              size: AppButtonSize.large,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
