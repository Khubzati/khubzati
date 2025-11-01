import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/restaurant_owner/analytics/application/blocs/restaurant_analytics_bloc.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

@RoutePage()
class RestaurantAnalyticsScreen extends StatelessWidget {
  const RestaurantAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantAnalyticsBloc(
        analyticsService: context.read(),
      )..add(const LoadRestaurantAnalytics()),
      child: const _RestaurantAnalyticsView(),
    );
  }
}

class _RestaurantAnalyticsView extends StatefulWidget {
  const _RestaurantAnalyticsView();

  @override
  State<_RestaurantAnalyticsView> createState() =>
      _RestaurantAnalyticsViewState();
}

class _RestaurantAnalyticsViewState extends State<_RestaurantAnalyticsView> {
  String _selectedPeriod = 'today';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.app_restaurant_owner_analytics_title.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
          ),
        ],
      ),
      body: Column(
        children: [
          // Period Selector
          _buildPeriodSelector(context),

          // Analytics Content
          Expanded(
            child:
                BlocBuilder<RestaurantAnalyticsBloc, RestaurantAnalyticsState>(
              builder: (context, state) {
                if (state is RestaurantAnalyticsLoading) {
                  return const AppLoadingWidget(
                    message: 'Loading analytics...',
                  );
                }

                if (state is RestaurantAnalyticsError) {
                  return _buildErrorWidget(context, state.message);
                }

                if (state is RestaurantAnalyticsLoaded) {
                  return _buildAnalyticsContent(context, state);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final periods = [
      {
        'key': 'today',
        'label': LocaleKeys.app_restaurant_owner_analytics_today.tr()
      },
      {
        'key': 'week',
        'label': LocaleKeys.app_restaurant_owner_analytics_this_week.tr()
      },
      {
        'key': 'month',
        'label': LocaleKeys.app_restaurant_owner_analytics_this_month.tr()
      },
      {
        'key': 'year',
        'label': LocaleKeys.app_restaurant_owner_analytics_this_year.tr()
      },
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final period = periods[index];
          final isSelected = _selectedPeriod == period['key'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(period['label']!),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedPeriod = period['key']!;
                  });
                  context.read<RestaurantAnalyticsBloc>().add(
                        LoadRestaurantAnalytics(period: period['key']!),
                      );
                }
              },
              selectedColor: AppColors.primaryBurntOrange.withOpacity(0.2),
              checkmarkColor: AppColors.primaryBurntOrange,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsContent(
      BuildContext context, RestaurantAnalyticsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sales Overview
          _buildSalesOverview(context, state.salesOverview),
          const SizedBox(height: 24),

          // Order Statistics
          _buildOrderStatistics(context, state.orderStatistics),
          const SizedBox(height: 24),

          // Popular Items
          _buildPopularItems(context, state.popularItems),
          const SizedBox(height: 24),

          // Revenue Chart Placeholder
          _buildRevenueChart(context),
          const SizedBox(height: 24),

          // Orders Chart Placeholder
          _buildOrdersChart(context),
        ],
      ),
    );
  }

  Widget _buildSalesOverview(
      BuildContext context, Map<String, dynamic> salesOverview) {
    final theme = context.theme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.app_restaurant_owner_analytics_sales_overview.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    LocaleKeys.app_restaurant_owner_analytics_total_sales.tr(),
                    'SAR ${salesOverview['total_sales']?.toStringAsFixed(2) ?? '0.00'}',
                    Icons.attach_money,
                    AppColors.primaryBurntOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    LocaleKeys.app_restaurant_owner_analytics_total_orders.tr(),
                    '${salesOverview['total_orders'] ?? 0}',
                    Icons.receipt_long,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              LocaleKeys.app_restaurant_owner_analytics_average_order_value
                  .tr(),
              'SAR ${salesOverview['average_order_value']?.toStringAsFixed(2) ?? '0.00'}',
              Icons.trending_up,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatistics(
      BuildContext context, Map<String, dynamic> orderStats) {
    final theme = context.theme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.app_restaurant_owner_analytics_order_statistics.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Pending',
                    '${orderStats['pending'] ?? 0}',
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Completed',
                    '${orderStats['completed'] ?? 0}',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Cancelled',
                    '${orderStats['cancelled'] ?? 0}',
                    Icons.cancel,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Processing',
                    '${orderStats['processing'] ?? 0}',
                    Icons.sync,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItems(
      BuildContext context, List<Map<String, dynamic>> popularItems) {
    final theme = context.theme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.app_restaurant_owner_analytics_top_selling_items.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (popularItems.isEmpty)
              _buildEmptyPopularItems(context)
            else
              ...popularItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _buildPopularItemCard(context, index + 1, item);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPopularItems(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.app_restaurant_owner_analytics_no_data_available.tr(),
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItemCard(
      BuildContext context, int rank, Map<String, dynamic> item) {
    final theme = context.theme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color:
                  rank <= 3 ? AppColors.primaryBurntOrange : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3 ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Unknown Item',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${item['quantity_sold'] ?? 0} sold',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            'SAR ${item['revenue']?.toStringAsFixed(2) ?? '0.00'}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBurntOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    final theme = context.theme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.app_restaurant_owner_analytics_revenue_chart.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Revenue Chart',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Chart implementation needed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersChart(BuildContext context) {
    final theme = context.theme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.app_restaurant_owner_analytics_orders_chart.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timeline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Orders Chart',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Chart implementation needed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading analytics',
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Retry',
            onPressed: () {
              context.read<RestaurantAnalyticsBloc>().add(
                    const LoadRestaurantAnalytics(),
                  );
            },
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon'),
        backgroundColor: AppColors.primaryBurntOrange,
      ),
    );
  }
}
