import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/styles/app_colors.dart';
import '../../../../../core/widgets/shared/app_button.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/order_bottom_sheets.dart';
import '../models/order_details_model.dart';

class BottomActions extends StatelessWidget {
  final OrderDetailsModel order;

  const BottomActions({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 96.h,
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 18,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 21.h, 16.w, 12.h),
        child: Row(
          children: [
            // Print invoice button
            Expanded(
              child: AppButton(
                text: "app.order_details.print_invoice".tr(),
                type: AppButtonType.outline,
                onPressed: () {
                  // TODO: Implement print invoice
                },
                icon: Icons.print,
              ),
            ),

            10.horizontalSpace,

            // Start preparation button
            Expanded(
              child: AppButton(
                text: "app.order_details.start_preparation".tr(),
                type: AppButtonType.primary,
                onPressed: () {
                  OrderBottomSheets.showOrderPreparation(
                    context: context,
                    orderNumber: order.id,
                    orderStatus: order.status,
                    orderAmount: AppFormatters.formatCurrencyJOD(order.total),
                    orderDate: order.date,
                    orderLocation: order.location,
                    restaurantName: order.customerName,
                    orderItems: order.products
                        .map((p) => {
                              'name': p.name,
                              'quantity': p.quantity,
                              'price': p.price,
                              'total': p.total,
                            })
                        .toList(),
                    onStartPreparation: () {
                      // TODO: Hook start preparation action
                    },
                    onPrintInvoice: () {
                      // TODO: Hook print invoice action
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
