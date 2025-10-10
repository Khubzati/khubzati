import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/features/notifications/application/blocs/notification_bloc.dart';

class NotificationBadge extends StatelessWidget {
  final Widget child;
  final bool showBadge;

  const NotificationBadge({
    super.key,
    required this.child,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(
        notificationService: context.read(),
      )..add(const GetUnreadCount()),
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          int unreadCount = 0;

          if (state is UnreadCountLoaded) {
            unreadCount = state.unreadCount;
          } else if (state is NotificationsLoaded) {
            unreadCount = state.unreadCount;
          }

          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  context.router.push(const NotificationRoute());
                },
                child: child,
              ),
              if (showBadge && unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
