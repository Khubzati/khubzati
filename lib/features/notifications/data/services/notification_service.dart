import 'package:injectable/injectable.dart';
import 'package:khubzati/features/notifications/domain/models/notification_item.dart';

@injectable
class NotificationService {
  Future<List<NotificationItem>> getNotifications() async {
    // Mock data - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return [
      // Today's notifications
      NotificationItem(
        id: '1',
        title: 'تم توصيل الطلب',
        description:
            'لوريم إيبسوم (Lorem ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى)',
        timeAgo: '1 س',
        iconUrl: 'assets/images/notification_icon.png',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 1)),
        type: NotificationType.orderDelivered,
      ),
      NotificationItem(
        id: '2',
        title: 'تم توصيل الطلب',
        description:
            'لوريم إيبسوم (Lorem ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى)',
        timeAgo: '2 س',
        iconUrl: 'assets/images/notification_icon.png',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        type: NotificationType.orderDelivered,
      ),
      NotificationItem(
        id: '3',
        title: 'تم توصيل الطلب',
        description:
            'لوريم إيبسوم (Lorem ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى)',
        timeAgo: '3 س',
        iconUrl: 'assets/images/notification_icon.png',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 3)),
        type: NotificationType.orderDelivered,
      ),
      // Yesterday's notifications
      NotificationItem(
        id: '4',
        title: 'تم توصيل الطلب',
        description:
            'لوريم إيبسوم (Lorem ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى)',
        timeAgo: '1 س',
        iconUrl: 'assets/images/notification_icon.png',
        isRead: false,
        createdAt: yesterday.add(const Duration(hours: 10)),
        type: NotificationType.orderDelivered,
      ),
      NotificationItem(
        id: '5',
        title: 'تم توصيل الطلب',
        description:
            'لوريم إيبسوم (Lorem ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى)',
        timeAgo: '2 س',
        iconUrl: 'assets/images/notification_icon.png',
        isRead: false,
        createdAt: yesterday.add(const Duration(hours: 8)),
        type: NotificationType.orderDelivered,
      ),
      NotificationItem(
        id: '6',
        title: 'تم توصيل الطلب',
        description:
            'لوريم إيبسوم (Lorem ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى)',
        timeAgo: '3 س',
        iconUrl: 'assets/images/notification_icon.png',
        isRead: true,
        createdAt: yesterday.add(const Duration(hours: 6)),
        type: NotificationType.orderDelivered,
      ),
    ];
  }

  Future<void> markAsRead(String notificationId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> markAllAsRead() async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> deleteNotification(String notificationId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
