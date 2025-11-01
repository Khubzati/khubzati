import 'package:equatable/equatable.dart';
import 'package:khubzati/features/notifications/domain/models/notification_item.dart';

class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<NotificationItem> todayNotifications;
  final List<NotificationItem> yesterdayNotifications;
  final int unreadCount;

  const NotificationLoaded({
    required this.todayNotifications,
    required this.yesterdayNotifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props =>
      [todayNotifications, yesterdayNotifications, unreadCount];

  NotificationLoaded copyWith({
    List<NotificationItem>? todayNotifications,
    List<NotificationItem>? yesterdayNotifications,
    int? unreadCount,
  }) {
    return NotificationLoaded(
      todayNotifications: todayNotifications ?? this.todayNotifications,
      yesterdayNotifications:
          yesterdayNotifications ?? this.yesterdayNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
