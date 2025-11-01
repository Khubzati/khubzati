import 'package:flutter/material.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantItem restaurant;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side - Content
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Icon(
                          restaurant.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              restaurant.isFavorite ? Colors.red : Colors.grey,
                          size: 20.sp,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    restaurant.name,
                    style: AppTextStyles.font20textDarkBrownbold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    restaurant.description,
                    style: AppTextStyles.font14TextW400OP8,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        restaurant.rating.toString(),
                        style: AppTextStyles.font14Primary700,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${restaurant.reviewCount} تقييم)',
                        style: AppTextStyles.font12PrimaryBurntOrange,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.primary,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        restaurant.deliveryTime,
                        style: AppTextStyles.font15TextW400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // Right side - Image
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.store,
                color: Colors.grey,
                size: 40.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
