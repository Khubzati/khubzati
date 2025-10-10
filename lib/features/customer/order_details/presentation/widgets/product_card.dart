import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/utils/formatters.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/product_info_column.dart';
import '../models/order_details_model.dart';

class ProductCard extends StatelessWidget {
  final OrderProduct product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main card content
        Container(
          alignment: Alignment.centerLeft,
          child: AppCard(
            backgroundColor: AppColors.pageBackground,
            borderRadius: 8.r,
            shadow: BoxShadow(
              // ignore: deprecated_member_use
              color: AppColors.primaryBurntOrange.withOpacity(0.13),
              blurRadius: 13.1,
            ),
            child: Container(
              width: 235.w,
              padding: EdgeInsets.only(left: 12.w, right: 36.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row: Price and Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      ProductInfoColumn(
                        label: "app.order_details.product_price".tr(),
                        value: AppFormatters.formatCurrencyJOD(product.price),
                      ),

                      // Type
                      ProductInfoColumn(
                        label: "app.order_details.product_type".tr(),
                        value: product.name,
                        alignRight: true,
                      ),
                    ],
                  ),

                  12.verticalSpace,

                  // Second row: Total and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total
                      ProductInfoColumn(
                        label: "app.order_details.product_total".tr(),
                        value: AppFormatters.formatCurrencyJOD(product.total),
                      ),

                      // Quantity
                      ProductInfoColumn(
                        label: "app.order_details.product_quantity".tr(),
                        value: "${product.quantity}x",
                        alignRight: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Product image - positioned to overlap half on card, half outside
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(
            top: 25.h,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Image(
              width: 130.w,
              image: AssetImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
