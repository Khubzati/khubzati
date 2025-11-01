import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/features/notifications/presentation/blocs/notification_bloc.dart';
import 'package:khubzati/features/notifications/presentation/blocs/notification_event.dart';
import 'package:khubzati/features/notifications/presentation/blocs/notification_state.dart'
    show NotificationState, NotificationLoaded;
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class MarkAllAsReadWidget extends StatelessWidget {
  const MarkAllAsReadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoaded && state.unreadCount > 0) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: GestureDetector(
              onTap: () {
                context.read<NotificationBloc>().add(const MarkAllAsRead());
              },
              child: Text(
                LocaleKeys.app_notifications_mark_all_as_read.tr(),
                style: AppTextStyles.font16PrimaryBold,
                textAlign: TextAlign.right,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
