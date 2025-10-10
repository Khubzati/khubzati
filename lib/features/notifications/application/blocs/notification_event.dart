part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final int page;
  final int limit;
  final String? type; // 'order', 'promotion', 'system', etc.

  const LoadNotifications({
    this.page = 1,
    this.limit = 20,
    this.type,
  });

  @override
  List<Object?> get props => [page, limit, type];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllNotificationsAsRead extends NotificationEvent {
  const MarkAllNotificationsAsRead();
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

class ClearAllNotifications extends NotificationEvent {
  const ClearAllNotifications();
}

class GetUnreadCount extends NotificationEvent {
  const GetUnreadCount();
}
