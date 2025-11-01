import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final String iconUrl;
  final bool isRead;
  final DateTime createdAt;
  final NotificationType type;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.iconUrl,
    required this.isRead,
    required this.createdAt,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        timeAgo,
        iconUrl,
        isRead,
        createdAt,
        type,
      ];

  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? timeAgo,
    String? iconUrl,
    bool? isRead,
    DateTime? createdAt,
    NotificationType? type,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeAgo: timeAgo ?? this.timeAgo,
      iconUrl: iconUrl ?? this.iconUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }
}

enum NotificationType {
  orderDelivered,
  orderConfirmed,
  orderCancelled,
  promotion,
  system,
}
