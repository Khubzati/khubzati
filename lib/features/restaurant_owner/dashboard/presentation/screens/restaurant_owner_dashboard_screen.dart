import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_dashboard_bloc.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

@RoutePage()
class RestaurantOwnerDashboardScreen extends StatelessWidget {
  const RestaurantOwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantOwnerDashboardBloc(
        restaurantDashboardService: context.read(),
      )..add(const LoadRestaurantOwnerDashboard()),
      child: const _RestaurantDashboardView(),
    );
  }
}

class _RestaurantDashboardView extends StatelessWidget {
  const _RestaurantDashboardView();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.app_restaurant_owner_dashboard_title.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              context.router.push(const NotificationRoute());
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<RestaurantOwnerDashboardBloc,
          RestaurantOwnerDashboardState>(
        builder: (context, state) {
          if (state is RestaurantOwnerDashboardLoading) {
            return const AppLoadingWidget(
              message: 'Loading dashboard...',
            );
          }

          if (state is RestaurantOwnerDashboardError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<RestaurantOwnerDashboardBloc>().add(
                      const LoadRestaurantOwnerDashboard(),
                    );
              },
            );
          }

          if (state is RestaurantOwnerDashboardLoaded) {
            return _buildDashboardContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, RestaurantOwnerDashboardLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Status Card
          _buildRestaurantStatusCard(context, state),
          const SizedBox(height: 24),

          // Stats Cards
          _buildStatsSection(context, state),
          const SizedBox(height: 24),

          // Recent Orders
          _buildRecentOrdersSection(context, state),
          const SizedBox(height: 24),

          // Popular Dishes
          _buildPopularDishesSection(context, state),
        ],
      ),
    );
  }

  Widget _buildRestaurantStatusCard(
      BuildContext context, RestaurantOwnerDashboardLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isOpen = state.isOpen;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Restaurant Status',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isOpen
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isOpen ? 'Open' : 'Closed',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isOpen ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isOpen
                ? 'Your restaurant is currently open for orders'
                : 'Your restaurant is currently closed',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: isOpen ? 'Close Restaurant' : 'Open Restaurant',
            onPressed: () {
              context.read<RestaurantOwnerDashboardBloc>().add(
                    UpdateRestaurantOwnerStatus(isOpen: !isOpen),
                  );
            },
            type: isOpen ? AppButtonType.outline : AppButtonType.primary,
            size: AppButtonSize.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
      BuildContext context, RestaurantOwnerDashboardLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final stats = state.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Overview',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Orders',
                '${stats['total_orders'] ?? 0}',
                Icons.receipt_long,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Revenue',
                '\$${stats['total_revenue']?.toStringAsFixed(0) ?? '0'}',
                Icons.attach_money,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Avg. Order',
                '\$${stats['average_order_value']?.toStringAsFixed(2) ?? '0.00'}',
                Icons.shopping_cart,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Rating',
                '${stats['average_rating']?.toStringAsFixed(1) ?? '0.0'}',
                Icons.star,
                Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersSection(
      BuildContext context, RestaurantOwnerDashboardLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final recentOrders = state.recentOrders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to order management
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Navigate to order management'),
                    backgroundColor: context.colorScheme.primary,
                  ),
                );
              },
              child: Text(
                'View All',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentOrders.isEmpty)
          _buildEmptyOrders(context)
        else
          ...recentOrders
              .take(3)
              .map((order) => _buildOrderCard(context, order)),
      ],
    );
  }

  Widget _buildEmptyOrders(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No recent orders',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here once customers start placing them',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        // TODO: Navigate to order details
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getOrderStatusColor(order['status']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.receipt,
              color: _getOrderStatusColor(order['status']),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order['id']}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order['customer_name']} • \$${order['total']?.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order['created_at'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getOrderStatusColor(order['status']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              order['status'] ?? 'pending',
              style: theme.textTheme.labelSmall?.copyWith(
                color: _getOrderStatusColor(order['status']),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDishesSection(
      BuildContext context, RestaurantOwnerDashboardLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final popularDishes = state.popularItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Dishes',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to product management
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Navigate to product management'),
                    backgroundColor: context.colorScheme.primary,
                  ),
                );
              },
              child: Text(
                'Manage Menu',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (popularDishes.isEmpty)
          _buildEmptyDishes(context)
        else
          ...popularDishes.take(3).map((dish) => _buildDishCard(context, dish)),
      ],
    );
  }

  Widget _buildEmptyDishes(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: 48,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No popular dishes yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add dishes to your menu to see popularity stats',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDishCard(BuildContext context, Map<String, dynamic> dish) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.surfaceContainerHighest,
            ),
            child: dish['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      dish['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.fastfood,
                          color: colorScheme.onSurfaceVariant,
                          size: 24,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.fastfood,
                    color: colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish['name'] ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${dish['orders_count']} orders • \$${dish['price']?.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.trending_up,
            color: Colors.green,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final colorScheme = context.colorScheme;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on dashboard
            break;
          case 1:
            // Navigate to order management
            context.router.push(const RestaurantOrderManagementRoute());
            break;
          case 2:
            // Navigate to product management
            context.router.push(const RestaurantProductManagementRoute());
            break;
          case 3:
            // Navigate to analytics
            context.router.push(const RestaurantAnalyticsRoute());
            break;
        }
      },
    );
  }

  Color _getOrderStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.green;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
