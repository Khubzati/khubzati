import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/restaurant_owner/cart/application/cubits/cart_cubit.dart';
import 'package:khubzati/features/restaurant_owner/cart/presentation/widgets/cart_app_bar.dart';
import 'package:khubzati/features/restaurant_owner/cart/presentation/widgets/cart_content_widget.dart';
import 'package:khubzati/features/restaurant_owner/cart/presentation/widgets/cart_error_widget.dart';
import 'package:khubzati/features/restaurant_owner/cart/presentation/widgets/cart_summary_widget.dart';
import 'package:khubzati/features/restaurant_owner/cart/presentation/widgets/clear_cart_dialog.dart';
import 'package:khubzati/features/restaurant_owner/cart/presentation/widgets/empty_cart_widget.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onNavigateToHome;

  const CartScreen({
    super.key,
    this.onNavigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    // CartCubit is provided at the RestaurantOwnerHomeScreen level
    return _CartView(onNavigateToHome: onNavigateToHome);
  }
}

class _CartView extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const _CartView({this.onNavigateToHome});

  @override
  State<_CartView> createState() => _CartViewState();
}

class _CartViewState extends State<_CartView> {
  @override
  void initState() {
    super.initState();
    // Load cart when screen is first displayed if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cartCubit = context.read<CartCubit>();
        final state = cartCubit.state;
        // Only load if cart is in initial state (not already loaded)
        if (state is CartInitial) {
          cartCubit.loadCart();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamColor,
      appBar: CartAppBar(
        onNavigateToHome: widget.onNavigateToHome,
        onClearCart: () => ClearCartDialog.show(context),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return AppLoadingWidget(
              message: LocaleKeys.app_restaurant_owner_cart_title.tr(),
            );
          }

          if (state is CartError) {
            return CartErrorWidget(message: state.message);
          }

          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return EmptyCartWidget(
                onBrowseRestaurants: widget.onNavigateToHome ??
                    () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
              );
            }

            return CartContentWidget(items: state.items);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoaded && state.items.isNotEmpty) {
          return CartSummaryWidget(
            subtotal: state.subtotal,
            deliveryFee: state.deliveryFee,
            tax: state.tax,
            total: state.total,
            onCheckout: () => _handleCheckout(context),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _handleCheckout(BuildContext context) {
    // TODO: Navigate to checkout screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          LocaleKeys.app_restaurant_owner_cart_checkout_coming_soon.tr(),
        ),
        backgroundColor: AppColors.primaryBurntOrange,
      ),
    );
  }
}
