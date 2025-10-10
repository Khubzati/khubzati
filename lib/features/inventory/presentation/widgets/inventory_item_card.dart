import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../../../../core/theme/styles/app_text_style.dart';

class InventoryItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String price;
  final String quantity;

  const InventoryItemCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    // Card with stacked image on top, matching the provided HTML layout
    return SizedBox(
      height: 208.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card body
          Positioned.fill(
            top: 42.h,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9F2E4),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF965641).withOpacity(0.30),
                    blurRadius: 20.5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.app_inventory_title.tr(),
                          style: AppTextStyles.font16textDarkBrownBold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      description,
                      style: AppTextStyles.font15TextW400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'السعر: $price',
                            style: AppTextStyles.font15TextW400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            'الكمية: $quantity',
                            style: AppTextStyles.font15TextW400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Bottom bar button
                  Container(
                    height: 22.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC25E3E),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.app_inventory_details.tr(),
                      style: AppTextStyles.font15TextW400.copyWith(
                          fontSize: 12.sp, color: const Color(0xFFF9F2E4)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top image, overlapping the card
          Positioned(
            top: -2.h,
            left: 8.w,
            right: 8.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                Assets.images.toastPng.path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 40),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
