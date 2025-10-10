import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/notifications/application/blocs/notification_bloc.dart';

@RoutePage()
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _currentPage = 1;
  final int _limit = 20;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotifications(
          page: _currentPage,
          limit: _limit,
          type: _selectedType,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (type) {
              setState(() {
                _selectedType = type == 'all' ? null : type;
                _currentPage = 1;
              });
              context.read<NotificationBloc>().add(LoadNotifications(
                    page: _currentPage,
                    limit: _limit,
                    type: _selectedType,
                  ));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Notifications'),
              ),
              const PopupMenuItem(
                value: 'order',
                child: Text('Order Updates'),
              ),
              const PopupMenuItem(
                value: 'promotion',
                child: Text('Promotions'),
              ),
              const PopupMenuItem(
                value: 'system',
                child: Text('System'),
              ),
            ],
            child: const Icon(Icons.filter_list),
          ),
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              context
                  .read<NotificationBloc>()
                  .add(const MarkAllNotificationsAsRead());
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading && _currentPage == 1) {
            return const AppLoadingWidget(
              message: 'Loading notifications...',
            );
          }

          if (state is NotificationError && _currentPage == 1) {
            return _buildErrorState(context, state.message);
          }

          if (state is NotificationsLoaded) {
            return _buildNotificationsList(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: context.theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: context.theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Retry',
            onPressed: () {
              setState(() {
                _currentPage = 1;
              });
              context.read<NotificationBloc>().add(LoadNotifications(
                    page: _currentPage,
                    limit: _limit,
                    type: _selectedType,
                  ));
            },
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
      BuildContext context, NotificationsLoaded state) {
    if (state.notifications.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _currentPage = 1;
        });
        context.read<NotificationBloc>().add(LoadNotifications(
              page: _currentPage,
              limit: _limit,
              type: _selectedType,
            ));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.notifications.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < state.notifications.length) {
            return _buildNotificationCard(context, state.notifications[index]);
          } else if (state.hasMore) {
            // Load more indicator
            _loadMoreNotifications();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You\'re all caught up! New notifications will appear here.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, Map<String, dynamic> notification) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isRead = notification['is_read'] == true;
    final type = notification['type'] ?? 'system';

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        if (!isRead) {
          context.read<NotificationBloc>().add(
                MarkNotificationAsRead(notificationId: notification['id']),
              );
        }
        _handleNotificationTap(notification);
      },
      child: Row(
        children: [
          // Notification Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getNotificationColor(type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              _getNotificationIcon(type),
              color: _getNotificationColor(type),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Notification Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification['title'] ?? 'Notification',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight:
                              isRead ? FontWeight.w500 : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification['body'] ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      _formatDate(notification['created_at']),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onPressed: () {
                        _showDeleteConfirmation(context, notification);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'promotion':
        return Icons.local_offer;
      case 'system':
        return Icons.info;
      case 'delivery':
        return Icons.local_shipping;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'promotion':
        return Colors.orange;
      case 'system':
        return Colors.grey;
      case 'delivery':
        return Colors.green;
      case 'payment':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'];
    final data = notification['data'];

    switch (type) {
      case 'order':
        // Navigate to order details
        if (data != null && data['order_id'] != null) {
          // TODO: Navigate to order details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Navigate to order ${data['order_id']}'),
            ),
          );
        }
        break;
      case 'promotion':
        // Navigate to promotions or specific offer
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navigate to promotions'),
          ),
        );
        break;
      case 'delivery':
        // Navigate to delivery tracking
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navigate to delivery tracking'),
          ),
        );
        break;
      default:
        // Handle other notification types
        break;
    }
  }

  void _loadMoreNotifications() {
    setState(() {
      _currentPage++;
    });
    context.read<NotificationBloc>().add(LoadNotifications(
          page: _currentPage,
          limit: _limit,
          type: _selectedType,
        ));
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content:
            const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotificationBloc>().add(
                    DeleteNotification(notificationId: notification['id']),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
