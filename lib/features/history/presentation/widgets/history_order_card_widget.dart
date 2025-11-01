// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/styles/app_colors.dart';
import '../../../../core/theme/styles/app_text_style.dart';

class HistoryOrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback? onTap;

  const HistoryOrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = order['status'] == 'completed';
    final isCancelled = order['status'] == 'cancelled';

    // Determine colors based on status
    final statusColor = isCompleted
        ? AppColors.tertiaryOliveGreen
        : isCancelled
            ? AppColors.error
            : Colors.orange;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
        child: SizedBox(
          height: 180.h,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                height: 160.h,
                right: 72.w,
                child: Container(
                  height: 150.h,
                  width: 280.w,
                  decoration: BoxDecoration(
                    color: AppColors.pageBackground,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 13.1,
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.pageBackground,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              Positioned(
                right: 80.w,
                left: 4.w,
                top: 56.h,
                child: Text(
                  'مطعم السروات',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.font15TextW400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                right: 80.w,
                left: 4.w,
                top: 121,
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.textDarkBrown,
                      size: 14.sp,
                    ),
                    1.horizontalSpace,
                    Text(
                      '6:00 - 8:00 ص، 9/9/2024',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.font14TextW400OP8,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 80.w,
                left: 4.w,
                top: 12.h,
                child: Text(
                  '#طلب12347897473',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.font16BurntOrange500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                left: 4.w,
                height: 2.h,
                top: 12.h,
                right: 320.w,
                child: Icon(
                  size: 14.sp,
                  weight: 700,
                  Icons.arrow_forward_ios_outlined,
                  color: AppColors.primaryBurntOrange,
                ),
              ),
              Positioned(
                left: 6.w,
                width: 64.w,
                top: 54.h,
                height: 24.h,
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      child: Text(
                        '230.50',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.font16textDarkBrownBold.copyWith(
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Positioned(
                      bottom: 4.h,
                      left: 0.w,
                      child: Text(
                        'د.أ',
                        style: AppTextStyles.font15TextW400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 12.w,
                top: 82.h,
                height: 1.h,
                child: Container(
                  width: 250.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.primaryBurntOrange, width: 1),
                  ),
                ),
              ),
              Positioned(
                right: 78.w,
                left: 4.w,
                top: 92.h,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textDarkBrown,
                      size: 16.sp,
                    ),
                    Text(
                      'عمان، وادي السير، الدوار السابع',
                      style: AppTextStyles.font14TextW400OP8,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.w,
                width: 70.w,
                top: 0,
                height: 160.h,
                child: Stack(
                  children: [
                    Positioned(
                      width: 70.w,
                      top: 0,
                      height: 160.h,
                      child: Container(
                        width: 70,
                        height: 150,
                        decoration: BoxDecoration(
                          color: statusColor,
                          border: Border.all(
                            color: AppColors.background,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 17.w,
                      width: 37,
                      top: 43,
                      height: 63,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0.w,
                            width: 37.w,
                            top: 0,
                            child: Icon(
                              size: 32.h,
                              isCancelled
                                  ? Icons.cancel_outlined
                                  : Icons.task_alt,
                              color: AppColors.surface,
                            ),
                          ),
                          Positioned(
                            left: 1,
                            top: 45,
                            child: Text(
                              isCancelled ? 'ملغي' : 'مكتمل',
                              textAlign: TextAlign.right,
                              style: AppTextStyles.font12PrimaryBurntOrange
                                  .copyWith(
                                color: AppColors.surface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }
}
