import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/styles/app_colors.dart';
import '../../../../../core/theme/styles/app_text_style.dart';
import '../../../../../core/widgets/shared_app_background.dart';
import '../../../../../core/widgets/confirmation_dialog_widget.dart';
import '../../../../../gen/assets.gen.dart';

class OrderDetailsHeader extends StatelessWidget {
  final String orderId;

  const OrderDetailsHeader({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
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
                  "app.order_details.title".tr(),
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
          Positioned(
            left: 16.w,
            top: 71.h,
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_sharp,
                size: 24.sp,
                color: AppColors.secondaryLightCream,
              ),
              onSelected: (String value) {
                switch (value) {
                  case 'print_receipt':
                    // Handle print receipt
                    _showPrintReceiptDialog(context);
                    break;
                  case 'share_order':
                    // Handle share order
                    _showShareOrderDialog(context);
                    break;
                  case 'view_invoice':
                    // Handle view invoice
                    _showViewInvoiceDialog(context);
                    break;
                  case 'cancel_order':
                    // Handle cancel order
                    _showCancelOrderDialog(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'print_receipt',
                  child: Row(
                    children: [
                      Icon(Icons.print,
                          size: 20.sp, color: AppColors.primaryBurntOrange),
                      SizedBox(width: 12.w),
                      Text(
                        'app.order_details.print_receipt'.tr(),
                        style: AppTextStyles.font14TextW400OP8,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'share_order',
                  child: Row(
                    children: [
                      Icon(Icons.share,
                          size: 20.sp, color: AppColors.primaryBurntOrange),
                      SizedBox(width: 12.w),
                      Text(
                        'app.order_details.share_order'.tr(),
                        style: AppTextStyles.font14TextW400OP8,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'view_invoice',
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long,
                          size: 20.sp, color: AppColors.primaryBurntOrange),
                      SizedBox(width: 12.w),
                      Text(
                        'app.order_details.view_invoice'.tr(),
                        style: AppTextStyles.font14TextW400OP8,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'cancel_order',
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined,
                          size: 20.sp, color: AppColors.error),
                      SizedBox(width: 12.w),
                      Text(
                        'app.order_details.cancel_order'.tr(),
                        style: AppTextStyles.font14TextW400OP8.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPrintReceiptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('app.order_details.print_receipt'.tr()),
          content: Text('app.order_details.print_receipt_message'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('app.common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement actual print functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('app.order_details.printing_receipt'.tr())),
                );
              },
              child: Text('app.common.print'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showShareOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('app.order_details.share_order'.tr()),
          content: Text('app.order_details.share_order_message'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('app.common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement actual share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('app.order_details.sharing_order'.tr())),
                );
              },
              child: Text('app.common.share'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showViewInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('app.order_details.view_invoice'.tr()),
          content: Text('app.order_details.view_invoice_message'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('app.common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement actual invoice view functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('app.order_details.opening_invoice'.tr())),
                );
              },
              child: Text('app.common.view'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showCancelOrderDialog(BuildContext context) {
    ConfirmationDialogWidget.show(
      context: context,
      svgAssetPath: Assets.images.baker,
      title: 'app.order_details.cancel_order_confirmation'.tr(),
      message: 'app.order_details.cancel_order_warning'.tr(),
      confirmButtonText: 'app.order_details.yes_confirm'.tr(),
      cancelButtonText: 'app.order_details.no_cancel'.tr(),
      confirmButtonColor: AppColors.primaryBurntOrange,
      onConfirm: () {
        Navigator.of(context).pop(); // Close confirmation dialog
        // Show success dialog
        _showOrderCancelledDialog(context);
      },
      onCancel: () {
        Navigator.of(context).pop(); // Close confirmation dialog
      },
    );
  }

  void _showOrderCancelledDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialogWidget(
        svgAssetPath: Assets.images.sucessfullBakery,
        title: 'app.order_details.order_cancelled'.tr(),
        message: 'app.order_details.order_cancelled_success'.tr(),
        confirmButtonText: 'app.common.ok'.tr(),
        cancelButtonText: '', // Hide cancel button for success dialog
        confirmButtonColor: AppColors.success,
        onConfirm: () {
          Navigator.of(context).pop(); // Close success dialog
          Navigator.of(context).pop(); // Go back to history screen
        },
      ),
    );
  }
}
