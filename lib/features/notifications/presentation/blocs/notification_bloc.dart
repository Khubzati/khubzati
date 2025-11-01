import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/notifications/data/services/notification_service.dart';
import 'package:khubzati/features/notifications/presentation/blocs/notification_event.dart';
import 'package:khubzati/features/notifications/presentation/blocs/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  NotificationBloc({required NotificationService notificationService})
      : _notificationService = notificationService,
        super(const NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<DeleteNotification>(_onDeleteNotification);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());
    try {
      final notifications = await _notificationService.getNotifications();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      final todayNotifications = notifications
          .where((notification) =>
              notification.createdAt.isAfter(today) &&
              notification.createdAt.isBefore(now))
          .toList();

      final yesterdayNotifications = notifications
          .where((notification) =>
              notification.createdAt.isAfter(yesterday) &&
              notification.createdAt.isBefore(today))
          .toList();

      final unreadCount =
          notifications.where((notification) => !notification.isRead).length;

      emit(NotificationLoaded(
        todayNotifications: todayNotifications,
        yesterdayNotifications: yesterdayNotifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError('Failed to load notifications: ${e.toString()}'));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        await _notificationService.markAsRead(event.notificationId);

        final updatedTodayNotifications = currentState.todayNotifications
            .map((notification) => notification.id == event.notificationId
                ? notification.copyWith(isRead: true)
                : notification)
            .toList();

        final updatedYesterdayNotifications = currentState
            .yesterdayNotifications
            .map((notification) => notification.id == event.notificationId
                ? notification.copyWith(isRead: true)
                : notification)
            .toList();

        final unreadCount = [
          ...updatedTodayNotifications,
          ...updatedYesterdayNotifications
        ].where((notification) => !notification.isRead).length;

        emit(currentState.copyWith(
          todayNotifications: updatedTodayNotifications,
          yesterdayNotifications: updatedYesterdayNotifications,
          unreadCount: unreadCount,
        ));
      } catch (e) {
        emit(NotificationError(
            'Failed to mark notification as read: ${e.toString()}'));
      }
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        await _notificationService.markAllAsRead();

        final updatedTodayNotifications = currentState.todayNotifications
            .map((notification) => notification.copyWith(isRead: true))
            .toList();

        final updatedYesterdayNotifications = currentState
            .yesterdayNotifications
            .map((notification) => notification.copyWith(isRead: true))
            .toList();

        emit(currentState.copyWith(
          todayNotifications: updatedTodayNotifications,
          yesterdayNotifications: updatedYesterdayNotifications,
          unreadCount: 0,
        ));
      } catch (e) {
        emit(NotificationError('Failed to mark all as read: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    add(const LoadNotifications());
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        await _notificationService.deleteNotification(event.notificationId);

        final updatedTodayNotifications = currentState.todayNotifications
            .where((notification) => notification.id != event.notificationId)
            .toList();

        final updatedYesterdayNotifications = currentState
            .yesterdayNotifications
            .where((notification) => notification.id != event.notificationId)
            .toList();

        final unreadCount = [
          ...updatedTodayNotifications,
          ...updatedYesterdayNotifications
        ].where((notification) => !notification.isRead).length;

        emit(currentState.copyWith(
          todayNotifications: updatedTodayNotifications,
          yesterdayNotifications: updatedYesterdayNotifications,
          unreadCount: unreadCount,
        ));
      } catch (e) {
        emit(NotificationError(
            'Failed to delete notification: ${e.toString()}'));
      }
    }
  }
}
