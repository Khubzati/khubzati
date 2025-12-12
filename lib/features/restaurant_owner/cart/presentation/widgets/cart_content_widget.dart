import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/features/restaurant_owner/cart/application/cubits/cart_cubit.dart';
import 'package:khubzati/features/restaurant_owner/cart/domain/models/cart_item.dart';
import 'package:khubzati/features/restaurant_owner/cart/presentation/widgets/cart_item_card.dart';

class CartContentWidget extends StatelessWidget {
  final List<CartItem> items;

  const CartContentWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: AppColors.creamColor,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 4.h),
        itemBuilder: (context, index) {
          final item = items[index];
          return CartItemCard(
            item: item,
            onIncreaseQuantity: () => _handleIncreaseQuantity(context, item),
            onDecreaseQuantity: () => _handleDecreaseQuantity(context, item),
            onRemove: () => _handleRemoveItem(context, item),
          );
        },
      ),
    );
  }

  void _handleIncreaseQuantity(BuildContext context, CartItem item) {
    context.read<CartCubit>().updateItemQuantity(
          item.productId,
          item.quantity + 1,
        );
  }

  void _handleDecreaseQuantity(BuildContext context, CartItem item) {
    if (item.quantity > 1) {
      context.read<CartCubit>().updateItemQuantity(
            item.productId,
            item.quantity - 1,
          );
    }
  }

  void _handleRemoveItem(BuildContext context, CartItem item) {
    context.read<CartCubit>().removeItemFromCart(item.productId);
  }
}
