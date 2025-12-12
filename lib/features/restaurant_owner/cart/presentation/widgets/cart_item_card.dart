import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_shadows.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/features/restaurant_owner/cart/domain/models/cart_item.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      shadow: AppShadows.blur50BlackOP10OffsetDy4.single,
      backgroundColor: AppColors.secondaryLightCream,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Section (1/3): Image and Quantity Controls

          Expanded(
            child: _buildProductInfo(context),
          ),
          // Right Section (2/3): Product Info

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.33,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryLightCream,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.textDarkBrown.withOpacity(0.1),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Image
                  _buildProductImage(context),
                  SizedBox(height: 12.h),
                  // Quantity Controls
                  _buildQuantityControls(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.25;
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        border: Border.all(
          color: AppColors.textDarkBrown.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                item.imageUrl!,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderIcon(imageSize);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryBurntOrange,
                      ),
                    ),
                  );
                },
              ),
            )
          : _buildPlaceholderIcon(imageSize),
    );
  }

  Widget _buildPlaceholderIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.secondaryLightCream,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.asset(
          'assets/images/toastPng.png',
          // fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to icon if image fails to load
            return Icon(
              Icons.restaurant_menu,
              color: AppColors.textDarkBrown.withOpacity(0.3),
              size: size * 0.4,
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Product Name with Delete Button
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.productName,
                style: AppTextStyles.font16textDarkBrownBold.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Description (Lorem Ipsum placeholder)
        Text(
          'لوريم إيبسوم',
          style: AppTextStyles.font14TextW400OP8.copyWith(
            fontSize: 12.sp,
            color: AppColors.textDarkBrown.withOpacity(0.6),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 16.h),
        // Price
        Text(
          '${LocaleKeys.app_restaurant_owner_cart_price.tr()} ${_formatPrice(item.totalPrice)}',
          style: AppTextStyles.font16textDarkBrownBold.copyWith(
            fontSize: 14.sp,
            color: AppColors.textDarkBrown,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width and adjust sizes accordingly
        final availableWidth = constraints.maxWidth;
        final spacing = 3.w; // Balanced spacing for touch targets
        final quantityBoxWidth = 34.w; // Optimized for readability
        final deleteButtonWidth = 22.w; // Adequate touch target

        // Calculate button size: (availableWidth - quantityBoxWidth - deleteButtonWidth - 4*spacing) / 2
        final totalSpacing = 4 * spacing; // 4 gaps between 5 elements
        final calculatedButtonSize = (availableWidth -
                quantityBoxWidth -
                deleteButtonWidth -
                totalSpacing) /
            2;
        // Clamp with buffer to prevent overflow
        final buttonSize = calculatedButtonSize.clamp(18.0, 22.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Plus Button with enhanced UX
            _buildQuantityButton(
              size: buttonSize,
              icon: Icons.add,
              onPressed: () {
                HapticFeedback.lightImpact();
                onIncreaseQuantity();
              },
              color: AppColors.primaryBurntOrange,
            ),
            SizedBox(width: spacing),
            // Quantity Display with better styling
            Container(
              width: quantityBoxWidth,
              height: 32.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primaryBurntOrange,
                  width: 1.5,
                ),
                color: AppColors.primaryBurntOrange.withOpacity(0.05),
              ),
              alignment: Alignment.center,
              child: Text(
                '${item.quantity}',
                style: AppTextStyles.font16textDarkBrownBold.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.primaryBurntOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: spacing),
            // Minus Button with enhanced UX
            _buildQuantityButton(
              size: buttonSize,
              icon: Icons.remove,
              onPressed: item.quantity > 1
                  ? () {
                      HapticFeedback.lightImpact();
                      onDecreaseQuantity();
                    }
                  : null,
              color: AppColors.primaryBurntOrange,
              isDisabled: item.quantity <= 1,
            ),
            SizedBox(width: spacing),
            // Delete Button with enhanced UX
            _buildDeleteButton(context, deleteButtonWidth),
          ],
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required double size,
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    bool isDisabled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: 32.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDisabled ? color.withOpacity(0.3) : color,
              width: 1.5,
            ),
            color: Colors.transparent,
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: isDisabled ? color.withOpacity(0.3) : color,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, double width) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDeleteConfirmation(context),
        borderRadius: BorderRadius.circular(width / 2),
        child: Container(
          width: width,
          height: 32.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.error,
              width: 1.5,
            ),
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.delete_outline,
            size: 16.sp,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with animated background
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.error.withOpacity(0.15),
                        AppColors.error.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: AppColors.error,
                    size: 32.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                // Title
                Text(
                  'حذف العنصر',
                  style: AppTextStyles.font16textDarkBrownBold.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.textDarkBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                // Content
                Text(
                  'هل أنت متأكد من حذف "${item.productName}" من السلة؟',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14TextW400OP8.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.textDarkBrown.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          HapticFeedback.lightImpact();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.textDarkBrown.withOpacity(0.3),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          LocaleKeys.app_restaurant_owner_cart_cancel.tr(),
                          style: AppTextStyles.font14TextW400OP8.copyWith(
                            fontSize: 15.sp,
                            color: AppColors.textDarkBrown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          HapticFeedback.mediumImpact();
                          onRemove();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_rounded,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'حذف',
                              style: AppTextStyles.font14TextW400OP8.copyWith(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ${LocaleKeys.app_restaurant_owner_cart_currency.tr()}';
  }
}
