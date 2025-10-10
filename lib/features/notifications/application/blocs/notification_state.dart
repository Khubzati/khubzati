part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<Map<String, dynamic>> notifications;
  final int unreadCount;
  final bool hasMore;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [notifications, unreadCount, hasMore];
}

class UnreadCountLoaded extends NotificationState {
  final int unreadCount;

  const UnreadCountLoaded({required this.unreadCount});

  @override
  List<Object?> get props => [unreadCount];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
