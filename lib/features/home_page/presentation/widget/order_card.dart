import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/constants/bread_assets.dart';
import '../../../../core/widgets/order_bottom_sheets.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/routes/app_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String status;
  final String amount;
  final String date;
  final String location;
  final List<String> productQuantities;
  final List<String>?
      productTypes; // optional: bread type keys matching BreadAssets

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.status,
    required this.amount,
    required this.date,
    required this.location,
    required this.productQuantities,
    this.productTypes,
  });

  void _showNotesBottomSheet(BuildContext context) {
    OrderBottomSheets.showNotes(
      context: context,
      notes:
          'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي ويُستخدم في صناعات المطابع ودور النشر.',
    );
  }

  void _showOrderPreparationBottomSheet(BuildContext context) {
    OrderBottomSheets.showOrderPreparation(
      context: context,
      orderNumber: orderNumber,
      orderStatus: status,
      orderAmount: amount,
      orderDate: date,
      orderLocation: location,
      orderItems: List.generate(
          productQuantities.length,
          (i) => {
                'type': (productTypes != null && i < (productTypes!.length))
                    ? productTypes![i]
                    : 'نوع خبز',
                'qty': productQuantities[i],
              }),
      onStartPreparation: () {},
      onPrintInvoice: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Order header

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Order number

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: '# ', style: AppTextStyles.font16PrimaryBold),
                    TextSpan(
                        text: 'طلب', style: AppTextStyles.font16PrimaryBold),
                    TextSpan(
                        text: orderNumber,
                        style: AppTextStyles.font16PrimaryBold),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.view_compact,
                  color: AppColors.primaryBurntOrange,
                  size: 30.w,
                ),
                onPressed: () {
                  context.router.push(OrderDetailsRoute(orderId: orderNumber));
                },
              ),
            ],
          ),
          12.verticalSpace,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Order amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'قيمة الطلب',
                    style: AppTextStyles.font15TextW400,
                  ),
                  4.verticalSpace,
                  RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: ' د.أ ', style: AppTextStyles.font15TextW400),
                        TextSpan(
                            text: amount.split('.')[0],
                            style: AppTextStyles.font16textDarkBrownBold),
                        TextSpan(
                          text: '.',
                          style: AppTextStyles.font16textDarkBrownBold,
                        ),
                        TextSpan(
                          text: amount.split('.')[1],
                          style: AppTextStyles.font16textDarkBrownBold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Order status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('حالة الطلب', style: AppTextStyles.font15TextW400),
                  SizedBox(height: 4.h),
                  Text(
                    status,
                    style: AppTextStyles.font16textDarkBrownBold.copyWith(
                      color: AppColors.primaryBurntOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          // Date and location
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التاريخ',
                    style: AppTextStyles.font15TextW400,
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Text(date, style: AppTextStyles.font16textDarkBrownBold),
                      4.verticalSpace,
                      Icon(
                        Icons.access_time,
                        color: AppColors.textDarkBrown,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ],
              ),

              // Location
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'الموقع',
                    style: AppTextStyles.font15TextW400,
                    textAlign: TextAlign.right,
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Text(
                        location,
                        style: AppTextStyles.font16textDarkBrownBold,
                        textAlign: TextAlign.right,
                      ),
                      4.verticalSpace,
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.textDarkBrown,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          16.verticalSpace,

          // Order items
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'قائمة الطلبات',
                style: AppTextStyles.font16textDarkBrownBold,
                textAlign: TextAlign.right,
              ),
              8.verticalSpace,
              Row(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 56.w,
                          height: 56.h,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.primaryBurntOrange),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Center(
                            child: _buildBreadVisual(index),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBurntOrange,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.r),
                                bottomLeft: Radius.circular(8.r),
                              ),
                            ),
                            child: Text(productQuantities[index],
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Start preparing order button
              AppElevatedButton(
                fixedSize: const Size(160, 40),
                onPressed: () => _showOrderPreparationBottomSheet(context),
                backgroundColor: AppColors.primaryBurntOrange,
                child: Center(
                  child: Text('بدء تحضير الطلب',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
              ),
              // Notes button
              AppElevatedButton(
                onPressed: () => _showNotesBottomSheet(context),
                fixedSize: const Size(160, 40),
                backgroundColor: AppColors.pageBackground,
                child: Text(
                  'ملاحظات',
                  style: TextStyle(
                    color: AppColors.primaryBurntOrange,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'GE Dinar One',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreadVisual(int index) {
    final type = (productTypes != null && index < (productTypes!.length))
        ? productTypes![index]
        : null;
    final asset = BreadAssets.assetForType(type);
    if (asset.endsWith('.svg')) {
      return SvgPicture.asset(
        asset,
        width: 28.w,
        height: 28.w,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      asset,
      width: 28.w,
      height: 28.w,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.bakery_dining,
        color: AppColors.primaryBurntOrange,
        size: 24.sp,
      ),
    );
  }
}
