import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class RestaurantOwnerFavoritesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onClearAll;

  const RestaurantOwnerFavoritesAppBar({
    super.key,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.secondaryLightCream,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.notifications_outlined,
          color: AppColors.textDarkBrown,
          size: 24.sp,
        ),
        onPressed: () {
          // TODO: Navigate to notifications
        },
      ),
      title: Text(
        LocaleKeys.app_restaurant_owner_home_favorites.tr(),
        style: AppTextStyles.font24Textbold,
      ),
      centerTitle: true,
      actions: [
        if (onClearAll != null)
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.textDarkBrown,
              size: 24.sp,
            ),
            onPressed: onClearAll,
            tooltip: LocaleKeys.app_favorites_clear_all.tr(),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}

