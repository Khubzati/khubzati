import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/assets.gen.dart';
import '../../domain/models/favorite_product.dart';

class FavoriteProductCard extends StatelessWidget {
  final FavoriteProduct product;
  final VoidCallback onTap;
  final VoidCallback onCartTap;
  final VoidCallback onFavoriteToggle;

  const FavoriteProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onCartTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryLightCream,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: SizedBox(
                height: 120.h,
                width: double.infinity,
                child: SvgPicture.asset(
                  Assets.images.resturant,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: 40.sp,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Product info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.font16textDarkBrownBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  4.verticalSpace,
                  Text(
                    product.bakeryName,
                    style: AppTextStyles.font12PrimaryBurntOrange.copyWith(
                      color: AppColors.textDarkBrown.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  8.verticalSpace,
                  // Price and action icons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Shopping cart on left
                      GestureDetector(
                        onTap: onCartTap,
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: AppColors.textDarkBrown,
                          size: 20.sp,
                        ),
                      ),
                      // Price in middle
                      Text(
                        '${product.price.toStringAsFixed(2)} د.أ',
                        style: AppTextStyles.font16textDarkBrownBold,
                      ),
                      // Heart icon on right
                      GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Icon(
                          Icons.favorite,
                          color: AppColors.primaryBurntOrange,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

