import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared_app_background.dart';
import 'package:khubzati/features/notifications/data/services/notification_service.dart';
import 'package:khubzati/features/notifications/presentation/blocs/notification_bloc.dart';
import 'package:khubzati/features/notifications/presentation/blocs/notification_event.dart';
import 'package:khubzati/features/notifications/presentation/blocs/notification_state.dart';
import 'package:khubzati/features/notifications/presentation/widgets/mark_all_as_read_widget.dart';
import 'package:khubzati/features/notifications/presentation/widgets/notification_section_widget.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

@RoutePage()
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(
        notificationService: NotificationService(),
      )..add(const LoadNotifications()),
      child: Scaffold(
        backgroundColor: AppColors.creamColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar with SharedAppBackground
            SharedAppBackground(
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.router.maybePop(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        LocaleKeys.app_notifications_title.tr(),
                        style: AppTextStyles.font24TextW700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const MarkAllAsReadWidget(),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(
                      child: AppLoadingWidget(),
                    );
                  } else if (state is NotificationError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: AppTextStyles.font14TextW400OP8,
                            textAlign: TextAlign.center,
                          ),
                          16.verticalSpace,
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<NotificationBloc>()
                                  .add(const LoadNotifications());
                            },
                            child: Text(LocaleKeys.app_common_retry.tr()),
                          ),
                        ],
                      ),
                    );
                  } else if (state is NotificationLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Today's Notifications
                          NotificationSectionWidget(
                            title: LocaleKeys.app_notifications_today.tr(),
                            notifications: state.todayNotifications,
                            emptyMessage: LocaleKeys
                                .app_notifications_no_notifications_today
                                .tr(),
                          ),
                          // Yesterday's Notifications
                          NotificationSectionWidget(
                            title: LocaleKeys.app_notifications_yesterday.tr(),
                            notifications: state.yesterdayNotifications,
                            emptyMessage: LocaleKeys
                                .app_notifications_no_notifications_yesterday
                                .tr(),
                          ),
                          20.verticalSpace,
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
