import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/driver/dashboard/application/blocs/driver_dashboard_bloc.dart';

@RoutePage()
class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverDashboardBloc(
        driverDashboardService: context.read(),
      )..add(const LoadDriverDashboard()),
      child: const _DriverDashboardView(),
    );
  }
}

class _DriverDashboardView extends StatelessWidget {
  const _DriverDashboardView();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Driver Dashboard',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
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
      body: BlocBuilder<DriverDashboardBloc, DriverDashboardState>(
        builder: (context, state) {
          if (state is DriverDashboardLoading) {
            return const AppLoadingWidget(
              message: 'Loading dashboard...',
            );
          }

          if (state is DriverDashboardError) {
            return _buildErrorState(context, state.message);
          }

          if (state is DriverDashboardLoaded) {
            return _buildDashboardContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
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
              context
                  .read<DriverDashboardBloc>()
                  .add(const LoadDriverDashboard());
            },
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, DriverDashboardLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver Status Card
          _buildDriverStatusCard(context, state),
          const SizedBox(height: 24),

          // Stats Cards
          _buildStatsSection(context, state),
          const SizedBox(height: 24),

          // Available Deliveries
          _buildAvailableDeliveriesSection(context, state),
          const SizedBox(height: 24),

          // Active Deliveries
          _buildActiveDeliveriesSection(context, state),
        ],
      ),
    );
  }

  Widget _buildDriverStatusCard(
      BuildContext context, DriverDashboardLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isOnline = state.isOnline;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Driver Status',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isOnline
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isOnline ? 'Online' : 'Offline',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isOnline ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isOnline
                ? 'You are currently online and available for deliveries'
                : 'You are currently offline and not receiving delivery requests',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: isOnline ? 'Go Offline' : 'Go Online',
            onPressed: () {
              context.read<DriverDashboardBloc>().add(
                    UpdateDriverStatus(isOnline: !isOnline),
                  );
            },
            type: isOnline ? AppButtonType.outline : AppButtonType.primary,
            size: AppButtonSize.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, DriverDashboardLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

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
                'Deliveries',
                '${state.totalDeliveries}',
                Icons.local_shipping,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Earnings',
                '\$${state.todayEarnings.toStringAsFixed(2)}',
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
                'Rating',
                state.rating.toStringAsFixed(1),
                Icons.star,
                Colors.amber,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Active',
                '${state.activeDeliveries.length}',
                Icons.delivery_dining,
                Colors.orange,
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

  Widget _buildAvailableDeliveriesSection(
      BuildContext context, DriverDashboardLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final availableDeliveries = state.availableDeliveries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Deliveries',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        if (availableDeliveries.isEmpty)
          _buildEmptyDeliveries(context, 'No available deliveries')
        else
          ...availableDeliveries
              .take(3)
              .map((delivery) => _buildDeliveryCard(context, delivery, true)),
      ],
    );
  }

  Widget _buildActiveDeliveriesSection(
      BuildContext context, DriverDashboardLoaded state) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final activeDeliveries = state.activeDeliveries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Deliveries',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        if (activeDeliveries.isEmpty)
          _buildEmptyDeliveries(context, 'No active deliveries')
        else
          ...activeDeliveries
              .map((delivery) => _buildDeliveryCard(context, delivery, false)),
      ],
    );
  }

  Widget _buildEmptyDeliveries(BuildContext context, String message) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      child: Column(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 48,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(
      BuildContext context, Map<String, dynamic> delivery, bool isAvailable) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getDeliveryStatusColor(delivery['status'])
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: _getDeliveryStatusColor(delivery['status']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery #${delivery['id']}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'From: ${delivery['pickup_address']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      'To: ${delivery['delivery_address']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${delivery['delivery_fee']?.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDeliveryStatusColor(delivery['status'])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      delivery['status'] ?? 'pending',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getDeliveryStatusColor(delivery['status']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isAvailable) ...[
            const SizedBox(height: 16),
            AppButton(
              text: 'Accept Delivery',
              onPressed: () {
                context.read<DriverDashboardBloc>().add(
                      AcceptDelivery(deliveryId: delivery['id'].toString()),
                    );
              },
              type: AppButtonType.primary,
              size: AppButtonSize.medium,
              isFullWidth: true,
            ),
          ] else ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Picked Up',
                    onPressed: () {
                      context.read<DriverDashboardBloc>().add(
                            UpdateDeliveryStatus(
                              deliveryId: delivery['id'].toString(),
                              status: 'picked_up',
                            ),
                          );
                    },
                    type: AppButtonType.outline,
                    size: AppButtonSize.medium,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'Delivered',
                    onPressed: () {
                      context.read<DriverDashboardBloc>().add(
                            UpdateDeliveryStatus(
                              deliveryId: delivery['id'].toString(),
                              status: 'delivered',
                            ),
                          );
                    },
                    type: AppButtonType.primary,
                    size: AppButtonSize.medium,
                  ),
                ),
              ],
            ),
          ],
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
          icon: Icon(Icons.local_shipping),
          label: 'Deliveries',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on dashboard
            break;
          case 1:
            // TODO: Navigate to deliveries list
            break;
          case 2:
            // TODO: Navigate to delivery history
            break;
          case 3:
            // TODO: Navigate to driver profile
            break;
        }
      },
    );
  }

  Color _getDeliveryStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'picked_up':
        return Colors.purple;
      case 'in_transit':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
