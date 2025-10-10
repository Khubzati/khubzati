// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/routes/app_router.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/shared/status_chip.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../gen/translations/locale_keys.g.dart';

class PreviousOrdersSection extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final EdgeInsetsGeometry? padding;
  final String? titleText;

  const PreviousOrdersSection({
    super.key,
    this.orders = const [],
    this.padding,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleText ?? LocaleKeys.app_order_history_title.tr(),
                style: AppTextStyles.font16textDarkBrownBold,
              ),
              // Optional: view all button (hidden for now)
            ],
          ),
          12.verticalSpace,

          if (orders.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: EmptyStateWidget.noOrders(),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => 10.verticalSpace,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _PreviousOrderCard(order: order);
              },
            ),
        ],
      ),
    );
  }
}

class _PreviousOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _PreviousOrderCard({required this.order});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'مكتمل':
        return AppColors.tertiaryOliveGreen;
      case 'cancelled':
      case 'ملغي':
        return AppColors.error;
      default:
        return AppColors.primaryBurntOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String id = order['id']?.toString() ?? '#';
    final String date = AppFormatters.formatDate(order['date']?.toString());
    final String status = order['status']?.toString() ?? '';
    final num totalNum = num.tryParse(order['total']?.toString() ?? '') ?? 0;
    final String total = AppFormatters.formatCurrencyJOD(totalNum);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xfff9f2e4),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header: View order + #OrderId
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${LocaleKeys.app_order_sheet_order_hash.tr()}$id',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.font16PrimaryBold,
                  overflow: TextOverflow.ellipsis,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.router.push(OrderDetailsRoute(orderId: id));
                  },
                  child: Row(
                    children: [
                      Text(
                        LocaleKeys.app_order_sheet_view_order.tr(),
                        style: AppTextStyles.font16PrimaryBold,
                      ),
                      4.horizontalSpace,
                      Icon(Icons.arrow_forward_ios,
                          size: 16.sp, color: AppColors.primaryBurntOrange),
                    ],
                  ),
                ),
              ],
            ),

            12.verticalSpace,

            // Status and amount (swapped left/right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.app_order_sheet_order_value.tr(),
                        style: AppTextStyles.font14TextW400OP8,
                      ),
                      6.verticalSpace,
                      Text(
                        total,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.font16textDarkBrownBold,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.app_order_sheet_order_status.tr(),
                        style: AppTextStyles.font14TextW400OP8,
                      ),
                      6.verticalSpace,
                      StatusChip(
                          label: status.isEmpty ? '-' : status,
                          color: _statusColor(status)),
                    ],
                  ),
                ),
              ],
            ),

            12.verticalSpace,

            // Date and location (swapped left/right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.app_order_sheet_location.tr(),
                        style: AppTextStyles.font14TextW400OP8,
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          Text(order['location']?.toString() ?? '-',
                              style: AppTextStyles.font16textDarkBrownBold
                                  .copyWith(fontWeight: FontWeight.w500)),
                          4.horizontalSpace,
                          Icon(Icons.location_on_outlined,
                              size: 16.sp, color: AppColors.textDarkBrown),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.app_order_sheet_date.tr(),
                        style: AppTextStyles.font14TextW400OP8,
                      ),
                      4.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(date,
                              style: AppTextStyles.font16textDarkBrownBold
                                  .copyWith(fontWeight: FontWeight.w500)),
                          4.horizontalSpace,
                          Icon(Icons.calendar_today_outlined,
                              size: 16.sp, color: AppColors.textDarkBrown),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
