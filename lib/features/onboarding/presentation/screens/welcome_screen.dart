import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/shared/app_button.dart';
import 'package:khubzati/core/routes/app_router.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              const Spacer(),
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 64,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 32),

              // App Title
              Text(
                'Khubzati',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // App Subtitle
              Text(
                'Your Gateway to Fresh Bread and Delicious Food',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Features
              _buildFeature(
                context,
                Icons.local_shipping,
                'Fast Delivery',
                'Get your orders delivered quickly and safely',
              ),
              const SizedBox(height: 24),
              _buildFeature(
                context,
                Icons.restaurant_menu,
                'Fresh Products',
                'Enjoy fresh bread and delicious meals from local vendors',
              ),
              const SizedBox(height: 24),
              _buildFeature(
                context,
                Icons.star,
                'Quality Assured',
                'All our vendors are verified for quality and hygiene',
              ),
              const Spacer(),

              // Get Started Button
              AppButton(
                text: 'Get Started',
                onPressed: () {
                  context.router.push(const RoleSelectionRoute());
                },
                type: AppButtonType.primary,
                size: AppButtonSize.large,
                isFullWidth: true,
              ),
              const SizedBox(height: 16),

              // Already have account
              TextButton(
                onPressed: () {
                  context.router.push(const LoginRoute());
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 24,
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
