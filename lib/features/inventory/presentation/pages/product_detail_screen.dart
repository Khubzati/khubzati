// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/gen/assets.gen.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared_bottom_navbar.dart';
import 'package:khubzati/core/widgets/shared_app_background.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:khubzati/core/routes/app_router.dart';

@RoutePage()
class InventoryProductDetailScreen extends StatelessWidget {
  final String productId;
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String unit;
  final String imageUrl;

  const InventoryProductDetailScreen({
    super.key,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          // Main content
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header section
                  _buildHeader(context),
                  24.verticalSpace,

                  // Product image
                  _buildProductImage(),
                  16.verticalSpace,
                  // Product information container
                  _buildProductInfo(),

                  // Nutritional value container
                  _buildNutritionalInfo(),

                  // Bottom spacing for navigation bar
                  120.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SharedBottomNavbar(
        currentIndex:
            1, // Inventory page index (since this is a product detail from inventory)
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 125.h,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: SharedAppBackground(
              fit: BoxFit.cover,
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Title and back arrow
          Positioned(
            left: 216.w,
            top: 71.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 24.sp,
                    color: AppColors.secondaryLightCream,
                  ),
                ),
                Text(
                  LocaleKeys.app_inventory_product_details.tr(),
                  style: AppTextStyles.font16textDarkBrownBold.copyWith(
                    color: AppColors.secondaryLightCream,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Edit button
          Positioned(
            left: 16.w,
            top: 71.h,
            child: IconButton(
              onPressed: () => context.router.push(
                EditProductRoute(
                  productId: productId,
                  name: name,
                  description: description,
                  price: price,
                  quantity: quantity,
                  unit: unit,
                  imageUrl: imageUrl,
                ),
              ),
              icon: Icon(
                Icons.edit_square,
                size: 24.sp,
                color: AppColors.secondaryLightCream,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Center(
        child: Container(
          height: 165.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              Assets.images.toastPng.path,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 40);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Row 1: Category and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.app_inventory_category.tr(),
                    style: AppTextStyles.font14Primary700,
                  ),
                  4.verticalSpace,
                  Text(
                    name,
                    style: AppTextStyles.font16textDarkBrownBold,
                  ),
                ],
              ),

              // Price section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.app_inventory_price_per_quantity.tr(),
                    style: AppTextStyles.font14Primary700,
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Text(
                        price.split('.').isNotEmpty
                            ? price.split('.')[0]
                            : price,
                        style: AppTextStyles.font16textDarkBrownBold,
                      ),
                      if (price.contains('.'))
                        Text(
                          '.${price.split('.')[1]}',
                          style: AppTextStyles.font16textDarkBrownBold,
                        ),
                      4.verticalSpace,
                      Text(
                        'د.أ',
                        style: AppTextStyles.font16textDarkBrownBold,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          16.verticalSpace,

          // Row 2: Available and Unit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Available section
              Column(
                children: [
                  Text(
                    LocaleKeys.app_inventory_available.tr(),
                    style: AppTextStyles.font14Primary700,
                  ),
                  4.verticalSpace,
                  Text(
                    quantity,
                    style: AppTextStyles.font16textDarkBrownBold,
                  ),
                ],
              ),
              // Unit section
              Column(
                children: [
                  Text(
                    LocaleKeys.app_inventory_unit.tr(),
                    style: AppTextStyles.font14Primary700,
                  ),
                  4.verticalSpace,
                  Text(
                    unit,
                    style: AppTextStyles.font16textDarkBrownBold,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      constraints: BoxConstraints(
        minHeight: 97.h,
        maxHeight: 120.h,
      ),
      decoration: ShapeDecoration(
        color: AppColors.creamColor, // beige
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.app_inventory_nutritional_value.tr(),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.font14Primary700,
                ),
                Text(
                  LocaleKeys.app_inventory_calories.tr(),
                  style: AppTextStyles.font14Primary700,
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('150', style: AppTextStyles.font16textDarkBrownBold),
                Text('100', style: AppTextStyles.font16textDarkBrownBold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
