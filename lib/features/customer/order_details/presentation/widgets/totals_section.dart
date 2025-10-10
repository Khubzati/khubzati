import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/styles/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/shared/app_card.dart';
import '../../../../../core/widgets/shared/total_row.dart';
import '../models/order_details_model.dart';

class TotalsSection extends StatelessWidget {
  final OrderDetailsModel order;

  const TotalsSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(12.w),
      backgroundColor: AppColors.pageBackground,
      borderRadius: 0,
      border: const Border(
        top: BorderSide(
          color: AppColors.primaryBurntOrange,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // Tax row
          TotalRow(
            label: "app.order_details.tax".tr(),
            value: AppFormatters.formatCurrencyJOD(order.tax),
          ),

          12.verticalSpace,

          // Delivery row
          TotalRow(
            label: "app.order_details.delivery".tr(),
            value: AppFormatters.formatCurrencyJOD(order.delivery),
          ),

          12.verticalSpace,

          // Payment method row
          Container(
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryBurntOrange,
                  width: 0.5,
                ),
              ),
            ),
            child: TotalRow(
              label: "app.order_details.payment_method".tr(),
              value: order.paymentMethod,
              showCurrency: false,
            ),
          ),

          12.verticalSpace,

          // Total row
          TotalRow(
            label: "app.order_details.total_value".tr(),
            value: AppFormatters.formatCurrencyJOD(order.total),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
