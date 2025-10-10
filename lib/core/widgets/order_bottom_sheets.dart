import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

import '../../gen/assets.gen.dart';
import '../theme/styles/app_colors.dart';
import '../theme/styles/app_text_style.dart';
import 'bottom_sheet_widget.dart';
import 'shared_bottom_sheet.dart';
import 'app_elevated_button.dart';

class OrderBottomSheets {
  // For showing notes
  static Future<void> showNotes({
    required BuildContext context,
    required String notes,
  }) {
    return SharedBottomSheet.show(
      context: context,
      content: Text(
        notes,
        style: AppTextStyles.font14TextW400OP8,
        textAlign: TextAlign.right,
      ),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.white,
      title: LocaleKeys.app_order_sheet_notes.tr(),
    );
  }

  // For showing order preparation details
  static Future<void> showOrderPreparation({
    required BuildContext context,
    required String orderNumber,
    required String orderStatus,
    required String orderAmount,
    required String orderDate,
    required String orderLocation,
    required List<Map<String, dynamic>> orderItems,
    required VoidCallback onStartPreparation,
    required VoidCallback onPrintInvoice,
    String? restaurantName,
    String? orderAddress,
    String? orderTime,
  }) {
    return SharedBottomSheet.show(
      context: context,
      content: _buildOrderPreparationContent(
        orderItems: orderItems,
        restaurantName: restaurantName,
        orderAddress: orderAddress,
        orderDate: orderDate,
        orderTime: orderTime ?? '2:30 pm',
        totalAmount: orderAmount,
      ),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: AppColors.pageBackground,
      height: MediaQuery.of(context).size.height * 0.8,
      footer: _buildOrderPreparationFooter(
        onStartPreparation: onStartPreparation,
        onPrintInvoice: onPrintInvoice,
        context: context,
      ),
    );
  }

  // Order preparation content
  static Widget _buildOrderPreparationContent({
    required List<Map<String, dynamic>> orderItems,
    required String? restaurantName,
    required String? orderAddress,
    required String orderDate,
    required String orderTime,
    required String totalAmount,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.app_order_sheet_sample_items.tr(),
              style: AppTextStyles.font16textDarkBrownBold,
            ),
            // Price

            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: totalAmount.split('.')[0],
                    style: AppTextStyles.font16textDarkBrownBold,
                  ),
                  if (totalAmount.contains('.'))
                    TextSpan(
                      text: '.${totalAmount.split('.')[1]}',
                      style: AppTextStyles.font16textDarkBrownBold,
                    ),
                  TextSpan(
                    text: ' ${LocaleKeys.app_order_sheet_currency_jod.tr()}',
                    style: AppTextStyles.font14TextW400OP8,
                  ),
                ],
              ),
            ),
            // Order items summary
          ],
        ),
        16.verticalSpace,
        // Restaurant name and logo
        Row(
          children: [
            Container(
              width: 47.w,
              height: 47.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: Assets.images.loginBreadJpg.provider(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        16.verticalSpace,
        // Order summary

        // Address
        if (orderAddress != null)
          Row(
            children: [
              Text(
                textAlign: TextAlign.start,
                orderAddress,
                style: AppTextStyles.font14TextW400OP8,
              ),
            ],
          ),
        16.verticalSpace,
        Container(height: 16.h, color: AppColors.primaryBurntOrange),
        16.verticalSpace,
        // Date and time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.app_order_sheet_date.tr(),
              style: AppTextStyles.font16textDarkBrownBold,
            ),
            Text(
              orderDate,
              style: AppTextStyles.font14TextW400OP8,
            ),
          ],
        ),
        16.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.app_order_sheet_time.tr(),
              style: AppTextStyles.font16textDarkBrownBold,
            ),
            Text(
              orderTime,
              style: AppTextStyles.font14TextW400OP8,
            ),
          ],
        ),
        16.verticalSpace,
        // Divider
        Container(
          height: 1.h,
          color: AppColors.primaryBurntOrange,
        ),
        16.verticalSpace,

        // Order details title
        Row(
          children: [
            Text(
              LocaleKeys.app_order_sheet_order_details.tr(),
              style: AppTextStyles.font16textDarkBrownBold,
              textAlign: TextAlign.right,
            ),
          ],
        ),
        16.verticalSpace,
        // Order items (static template)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.app_order_sheet_sample_item_names.tr(),
                  style: TextStyle(
                    color: AppColors.textDarkBrown,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'GE Dinar One',
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            // Quantities
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.app_order_sheet_sample_quantities.tr(),
                  style: TextStyle(
                    color: AppColors.textDarkBrown,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),

            // Prices
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.app_order_sheet_sample_prices.tr(),
                  style: TextStyle(
                    color: AppColors.textDarkBrown,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),

        16.verticalSpace,

        // Divider
        Container(
          height: 1.h,
          color: AppColors.primaryBurntOrange,
        ),

        16.verticalSpace,

        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocaleKeys.app_order_sheet_total_value.tr(),
                style: AppTextStyles.font16textDarkBrownBold),

            // Total amount
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: totalAmount.split('.')[0],
                      style: AppTextStyles.font16textDarkBrownBold),
                  if (totalAmount.contains('.'))
                    TextSpan(
                        text: '.${totalAmount.split('.')[1]}',
                        style: AppTextStyles.font16textDarkBrownBold),
                  TextSpan(
                      text: ' ${LocaleKeys.app_order_sheet_currency_jod.tr()}',
                      style: AppTextStyles.font16textDarkBrownBold),
                ],
              ),
            ),
          ],
        ),

        16.verticalSpace,
      ],
    );
  }

  // Order preparation footer with buttons
  static Widget _buildOrderPreparationFooter(
      {required VoidCallback onStartPreparation,
      required VoidCallback onPrintInvoice,
      required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          // Print invoice button
          Expanded(
            child: AppElevatedButton(
              onPressed: onPrintInvoice,
              backgroundColor: Colors.white,
              borderSide: const BorderSide(color: AppColors.primaryBurntOrange),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.app_order_sheet_print_invoice.tr(),
                    style: TextStyle(
                      color: AppColors.primaryBurntOrange,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'GE Dinar One',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.print,
                    color: AppColors.primaryBurntOrange,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Start preparation button
          Expanded(
            child: AppElevatedButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context)
                      .pop(); // close the current bottom sheet first
                }
                BottomSheetWidget.show(
                  context: context,
                  svgAssetPath: Assets.images.prepainrBaker,
                  title: LocaleKeys.app_order_sheet_order_in_preparation.tr(),
                );
                onStartPreparation();
              },
              backgroundColor: AppColors.primaryBurntOrange,
              child: Text(
                LocaleKeys.app_order_sheet_start_preparing_order.tr(),
                style: TextStyle(
                  color: AppColors.pageBackground,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'GE Dinar One',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
