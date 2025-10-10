import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/widgets/shared/app_card.dart';

@RoutePage()
class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final String transactionId;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Icon
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 80.sp,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Success Message
                    Text(
                      'Order Confirmed!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Your order has been successfully placed and payment has been processed.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Order Details Card
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context,
                            'Order ID',
                            '#$orderId',
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            'Transaction ID',
                            transactionId,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            'Status',
                            'Confirmed',
                            valueColor: Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            'Estimated Delivery',
                            '30-45 minutes',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // What's Next Card
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What\'s Next?',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildNextStepItem(
                            context,
                            Icons.restaurant,
                            'Restaurant is preparing your order',
                            'Your order is being prepared by the restaurant',
                          ),
                          const SizedBox(height: 16),
                          _buildNextStepItem(
                            context,
                            Icons.local_shipping,
                            'Driver will pick up your order',
                            'A driver will be assigned to deliver your order',
                          ),
                          const SizedBox(height: 16),
                          _buildNextStepItem(
                            context,
                            Icons.home,
                            'Order will be delivered',
                            'Your order will be delivered to your address',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  AppButton(
                    text: 'Track Order',
                    onPressed: () {
                      // TODO: Navigate to order tracking
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order tracking feature coming soon'),
                        ),
                      );
                    },
                    type: AppButtonType.primary,
                    size: AppButtonSize.large,
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Continue Shopping',
                    onPressed: () {
                      context.router.push(
                        const CustomerHomeRoute(),
                      );
                    },
                    type: AppButtonType.outline,
                    size: AppButtonSize.large,
                    isFullWidth: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: valueColor ?? colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
