import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../../domain/models/favorite_bakery.dart';
import 'favorite_bakery_card.dart';

class FavoriteBakeriesList extends StatelessWidget {
  final List<FavoriteBakery> bakeries;
  final Function(String) onBakeryTap;
  final Function(String) onFavoriteToggle;

  const FavoriteBakeriesList({
    super.key,
    required this.bakeries,
    required this.onBakeryTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (bakeries.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: bakeries.length,
      itemBuilder: (context, index) {
        final bakery = bakeries[index];
        return FavoriteBakeryCard(
          bakery: bakery,
          onTap: () => onBakeryTap(bakery.id),
          onFavoriteToggle: () => onFavoriteToggle(bakery.id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 80.sp,
              color: AppColors.textDarkBrown.withOpacity(0.4),
            ),
            24.verticalSpace,
            Text(
              LocaleKeys.app_restaurant_owner_favorites_empty_bakeries_title.tr(),
              style: AppTextStyles.font24Textbold,
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            Text(
              LocaleKeys.app_restaurant_owner_favorites_empty_bakeries_subtitle.tr(),
              style: AppTextStyles.font14TextW400OP8,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

