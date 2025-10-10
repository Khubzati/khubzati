import 'package:dio/dio.dart';
import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Get user's notifications
  Future<List<Map<String, dynamic>>> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.notifications,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (type != null) 'type': type,
        },
        requiresAuth: true,
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map &&
          response.containsKey('notifications') &&
          response['notifications'] is List) {
        return List<Map<String, dynamic>>.from(response['notifications']);
      }

      return [];
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.post(
        '${ApiConstants.notificationRead}$notificationId/read',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await _apiClient.post(
        '${ApiConstants.notifications}/mark-all-read',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.notifications}/$notificationId',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await _apiClient.delete(
        '${ApiConstants.notifications}/clear-all',
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.notifications}/unread-count',
        requiresAuth: true,
      );

      if (response is Map && response.containsKey('count')) {
        return response['count'] ?? 0;
      }

      return 0;
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Get notification by ID
  Future<Map<String, dynamic>> getNotificationById(
      String notificationId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.notifications}/$notificationId',
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Update notification preferences
  Future<void> updateNotificationPreferences({
    required bool orderUpdates,
    required bool promotions,
    required bool systemNotifications,
    required bool pushNotifications,
    required bool emailNotifications,
  }) async {
    try {
      await _apiClient.put(
        '${ApiConstants.notifications}/preferences',
        data: {
          'order_updates': orderUpdates,
          'promotions': promotions,
          'system_notifications': systemNotifications,
          'push_notifications': pushNotifications,
          'email_notifications': emailNotifications,
        },
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Get notification preferences
  Future<Map<String, dynamic>> getNotificationPreferences() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.notifications}/preferences',
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Send test notification (for development)
  Future<void> sendTestNotification({
    required String title,
    required String body,
    String? type,
  }) async {
    try {
      await _apiClient.post(
        '${ApiConstants.notifications}/test',
        data: {
          'title': title,
          'body': body,
          'type': type,
        },
        requiresAuth: true,
      );
    } catch (e) {
      throw _handleNotificationError(e);
    }
  }

  // Handle notification-specific errors
  ApiError _handleNotificationError(dynamic error) {
    if (error is DioException) {
      // Handle specific notification errors
      if (error.response?.statusCode == 400) {
        return ApiError(
          statusCode: 400,
          message: 'Invalid notification data.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 404) {
        return ApiError(
          statusCode: 404,
          message: 'Notification not found.',
          data: error.response?.data,
        );
      } else if (error.response?.statusCode == 403) {
        return ApiError(
          statusCode: 403,
          message: 'You are not authorized to access this notification.',
          data: error.response?.data,
        );
      }
    }

    // If it's already an ApiError, return it
    if (error is ApiError) {
      return error;
    }

    // Default error
    return ApiError(message: error.toString());
  }
}
