import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement RestaurantDashboardBloc for state management and API calls
// TODO: Implement UI for Sales Overview, Recent Orders, Quick Stats as per Figma (similar to Bakery Owner)
// TODO: Implement navigation to Product Management, Order Management, etc. for Restaurant

class RestaurantOwnerDashboardScreen extends StatelessWidget {
  static const String routeName = '/restaurant-owner-dashboard';

  const RestaurantOwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.restaurant_owner_dashboard_title.tr()), // Assuming this key exists
        centerTitle: true,
        // TODO: Add any actions like notifications or profile access
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Section 1: Sales Overview
              Text(LocaleKeys.restaurant_owner_dashboard_sales_overview_title.tr(), style: context.theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 8),
              // TODO: Implement Sales Chart or Stats Widget
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Text("Sales Overview Placeholder (Restaurant)", style: context.theme.textTheme.titleMedium),
              ),
              const SizedBox(height: 24),

              // Section 2: Recent Orders
              Text(LocaleKeys.restaurant_owner_dashboard_recent_orders_title.tr(), style: context.theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 8),
              // TODO: Implement Recent Orders List Widget (ListView.builder with OrderSummaryCard)
              // Placeholder for recent orders
              Column(
                children: List.generate(2, (index) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text("${LocaleKeys.restaurant_owner_dashboard_order_id_placeholder.tr()} #${3000 + index}"),
                    subtitle: Text("${LocaleKeys.restaurant_owner_dashboard_order_status_placeholder.tr()}: Confirmed"),
                    trailing: Text("\SAR ${70 + (index * 15)}.00"),
                    onTap: () {
                      // TODO: Navigate to specific order details for restaurant
                    },
                  ),
                )),
              ),
              const SizedBox(height: 24),

              // Section 3: Quick Stats / Actions
              Text(LocaleKeys.restaurant_owner_dashboard_quick_stats_title.tr(), style: context.theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 8),
              // TODO: Implement Quick Stats or Action Buttons (similar to Bakery Owner)
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  _buildQuickActionCard(context, icon: Icons.restaurant_menu_outlined, title: LocaleKeys.restaurant_owner_dashboard_manage_menu.tr(), onTap: () { /* TODO: Navigate to Menu/Product Management */ }),
                  _buildQuickActionCard(context, icon: Icons.receipt_long_outlined, title: LocaleKeys.restaurant_owner_dashboard_manage_orders.tr(), onTap: () { /* TODO: Navigate to Order Management */ }),
                  _buildQuickActionCard(context, icon: Icons.settings_outlined, title: LocaleKeys.restaurant_owner_dashboard_restaurant_settings.tr(), onTap: () { /* TODO: Navigate to Restaurant Settings */ }),
                ],
              ),
            ],
          ),
        ),
      ),
      // TODO: Implement BottomNavigationBar if applicable for owner flow
    );
  }

  Widget _buildQuickActionCard(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap}) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 24, // Adjust for padding and spacing
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: context.colorScheme.primary),
                const SizedBox(height: 8),
                Text(title, textAlign: TextAlign.center, style: context.theme.textTheme.titleSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

