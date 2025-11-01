import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/features/notifications/domain/models/notification_item.dart';
import 'package:khubzati/features/notifications/presentation/widgets/notification_item_widget.dart';

class NotificationSectionWidget extends StatelessWidget {
  final String title;
  final List<NotificationItem> notifications;
  final String emptyMessage;

  const NotificationSectionWidget({
    super.key,
    required this.title,
    required this.notifications,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Text(
            title,
            style: AppTextStyles.font16textDarkBrownBold,
            textAlign: TextAlign.right,
          ),
        ),
        // Notifications List
        if (notifications.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Center(
              child: Text(
                emptyMessage,
                style: AppTextStyles.font14TextW400OP8,
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.onSurface.withOpacity(0.1),
            ),
            itemBuilder: (context, index) {
              return NotificationItemWidget(
                notification: notifications[index],
              );
            },
          ),
      ],
    );
  }
}
