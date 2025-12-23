import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/assets.gen.dart';
import '../../domain/models/favorite_bakery.dart';

class FavoriteBakeryCard extends StatelessWidget {
  final FavoriteBakery bakery;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const FavoriteBakeryCard({
    super.key,
    required this.bakery,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.secondaryLightCream,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bakery image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: SizedBox(
                height: 150.h,
                width: double.infinity,
                child: SvgPicture.asset(
                  Assets.images.resturant,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.store,
                        color: Colors.grey,
                        size: 40.sp,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bakery info
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and heart icon row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          bakery.name,
                          style: AppTextStyles.font20textDarkBrownbold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      8.horizontalSpace,
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
                  8.verticalSpace,
                  // Description
                  Text(
                    bakery.description,
                    style: AppTextStyles.font14TextW400OP8,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  8.verticalSpace,
                  // Address
                  Text(
                    bakery.address,
                    style: AppTextStyles.font14TextW400OP8.copyWith(
                      color: AppColors.textDarkBrown.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  8.verticalSpace,
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber[700],
                        size: 16.sp,
                      ),
                      4.horizontalSpace,
                      Text(
                        '${bakery.rating.toStringAsFixed(1)}',
                        style: AppTextStyles.font14Primary700.copyWith(
                          color: AppColors.textDarkBrown,
                        ),
                      ),
                      4.horizontalSpace,
                      Text(
                        '(${bakery.reviewCount >= 1000 ? '${(bakery.reviewCount / 1000).toStringAsFixed(1)}k' : bakery.reviewCount} تقييم)',
                        style: AppTextStyles.font12PrimaryBurntOrange.copyWith(
                          color: AppColors.textDarkBrown.withOpacity(0.6),
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

