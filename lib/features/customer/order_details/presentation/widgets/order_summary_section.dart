import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/styles/app_colors.dart';
import '../../../../../core/theme/styles/app_text_style.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/shared/app_card.dart';
import '../../../../../core/widgets/shared/info_column.dart';
import '../models/order_details_model.dart';

class OrderSummarySection extends StatelessWidget {
  final OrderDetailsModel order;

  const OrderSummarySection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(12.w),
      backgroundColor: AppColors.pageBackground,
      borderRadius: 0,
      border: const Border(
        bottom: BorderSide(
          color: AppColors.primaryBurntOrange,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID
          Text(
            "#${"app.order_details.order_id".tr()}${order.id}",
            style: AppTextStyles.font16textDarkBrownBold.copyWith(
              color: AppColors.primaryBurntOrange,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          12.verticalSpace,

          // Order value and customer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Customer
              InfoColumn(
                label: "app.order_details.customer".tr(),
                value: order.customerName,
              ),
              // Order value
              InfoColumn(
                alignRight: true,
                label: "app.order_details.order_value".tr(),
                value: AppFormatters.formatCurrencyJOD(order.orderValue),
              ),
            ],
          ),

          12.verticalSpace,

          // Date and location row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location
              InfoColumn(
                label: "app.order_details.location".tr(),
                value: order.location,
                icon: Icons.location_on_outlined,
              ),

              // Date
              InfoColumn(
                label: "app.order_details.date".tr(),
                value: order.date,
                icon: Icons.calendar_today_outlined,
                alignRight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
