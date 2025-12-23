import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../../domain/models/favorite_product.dart';
import 'favorite_product_card.dart';

class FavoriteProductsGrid extends StatelessWidget {
  final List<FavoriteProduct> products;
  final Function(String) onProductTap;
  final Function(String) onCartTap;
  final Function(String) onFavoriteToggle;

  const FavoriteProductsGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onCartTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return FavoriteProductCard(
            product: product,
            onTap: () => onProductTap(product.id),
            onCartTap: () => onCartTap(product.id),
            onFavoriteToggle: () => onFavoriteToggle(product.id),
          );
        },
      ),
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
              Icons.favorite_border,
              size: 80.sp,
              color: AppColors.textDarkBrown.withOpacity(0.4),
            ),
            24.verticalSpace,
            Text(
              LocaleKeys.app_restaurant_owner_favorites_empty_items_title.tr(),
              style: AppTextStyles.font24Textbold,
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            Text(
              LocaleKeys.app_restaurant_owner_favorites_empty_items_subtitle.tr(),
              style: AppTextStyles.font14TextW400OP8,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

