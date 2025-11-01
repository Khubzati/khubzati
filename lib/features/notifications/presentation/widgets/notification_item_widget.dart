import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/features/notifications/domain/models/notification_item.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;

  const NotificationItemWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.creamColor
            : AppColors.secondaryLightCream,
        border: Border(
          bottom: BorderSide(
            color: AppColors.textDarkBrown.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Notification Icon
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.creamColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textDarkBrown.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.local_shipping,
              color: AppColors.textDarkBrown,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          // Notification Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.timeAgo,
                      style: AppTextStyles.font14TextW400OP8,
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBurntOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.title,
                  style: AppTextStyles.font16textDarkBrownBold,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.description,
                  style: AppTextStyles.font14TextW400OP8,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
