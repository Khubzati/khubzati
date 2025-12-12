import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/features/restaurant_owner/cart/application/cubits/cart_cubit.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNavigateToHome;
  final VoidCallback? onClearCart;

  const CartAppBar({
    super.key,
    this.onNavigateToHome,
    this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.creamColor,
      title: Text(
        LocaleKeys.app_restaurant_owner_cart_title.tr(),
        style: AppTextStyles.font24Textbold.copyWith(
          color: AppColors.textDarkBrown,
          fontSize: 24.sp,
        ),
      ),
      centerTitle: false,
      leading: _buildBackButton(context),
      actions: [
        _buildClearCartButton(context),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: AppColors.textDarkBrown,
        size: 24.sp,
      ),
      onPressed: () => _handleBackNavigation(context),
      tooltip: LocaleKeys.app_general_app_back.tr(),
    );
  }

  Widget _buildClearCartButton(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoaded && state.items.isNotEmpty) {
          return IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 24.sp,
            ),
            onPressed: () {
              if (onClearCart != null) {
                onClearCart!();
              }
            },
            tooltip: LocaleKeys.app_restaurant_owner_cart_clear_all.tr(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _handleBackNavigation(BuildContext context) {
    // Try router pop first, then fallback to Navigator or callback
    if (context.router.canPop()) {
      context.router.maybePop();
    } else if (onNavigateToHome != null) {
      onNavigateToHome!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
