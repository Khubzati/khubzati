import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/features/notifications/data/services/notification_service.dart';

part 'notification_event.dart';
part 'notification_state.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc({required this.notificationService})
      : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<GetUnreadCount>(_onGetUnreadCount);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final notifications = await notificationService.getNotifications(
        page: event.page,
        limit: event.limit,
        type: event.type,
      );

      final unreadCount = await notificationService.getUnreadCount();

      emit(NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
        hasMore: notifications.length == event.limit,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkNotificationAsRead(
      MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      try {
        await notificationService.markAsRead(event.notificationId);

        final updatedNotifications =
            currentState.notifications.map((notification) {
          if (notification['id'] == event.notificationId) {
            return {...notification, 'is_read': true};
          }
          return notification;
        }).toList();

        final newUnreadCount =
            (currentState.unreadCount - 1).clamp(0, double.infinity).toInt();

        emit(NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: newUnreadCount,
          hasMore: currentState.hasMore,
        ));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    }
  }

  Future<void> _onMarkAllNotificationsAsRead(
      MarkAllNotificationsAsRead event, Emitter<NotificationState> emit) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      try {
        await notificationService.markAllAsRead();

        final updatedNotifications =
            currentState.notifications.map((notification) {
          return {...notification, 'is_read': true};
        }).toList();

        emit(NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: 0,
          hasMore: currentState.hasMore,
        ));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteNotification(
      DeleteNotification event, Emitter<NotificationState> emit) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      try {
        await notificationService.deleteNotification(event.notificationId);

        final updatedNotifications = currentState.notifications
            .where((notification) => notification['id'] != event.notificationId)
            .toList();

        final wasUnread = currentState.notifications.firstWhere(
                (n) => n['id'] == event.notificationId,
                orElse: () => {})['is_read'] ==
            false;

        final newUnreadCount = wasUnread
            ? (currentState.unreadCount - 1).clamp(0, double.infinity).toInt()
            : currentState.unreadCount;

        emit(NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: newUnreadCount,
          hasMore: currentState.hasMore,
        ));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    }
  }

  Future<void> _onClearAllNotifications(
      ClearAllNotifications event, Emitter<NotificationState> emit) async {
    try {
      await notificationService.clearAllNotifications();
      emit(const NotificationsLoaded(
        notifications: [],
        unreadCount: 0,
        hasMore: false,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onGetUnreadCount(
      GetUnreadCount event, Emitter<NotificationState> emit) async {
    try {
      final unreadCount = await notificationService.getUnreadCount();
      emit(UnreadCountLoaded(unreadCount: unreadCount));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
