// lib/features/inventory/presentation/pages/inventory_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../../../../core/widgets/background_with_logo.dart';
import '../../../../core/widgets/shared/app_loading_widget.dart';
import '../../application/blocs/inventory_bloc.dart';
import '../widgets/inventory_item_card.dart';

@RoutePage()
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc()..add(const LoadInventory()),
      child: const _InventoryView(),
    );
  }
}

class _InventoryView extends StatelessWidget {
  const _InventoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background without logo and title
          BackgroundWithLogo(
            showLogo: false,
            showTitle: false,
            child: Container(),
          ),
          // Custom header with notification icon
          Positioned(
            top: 70.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocaleKeys.app_inventory_title.tr(),
                        style: AppTextStyles.font24TextW700),
                    8.verticalSpace,
                    Text(LocaleKeys.app_inventory_description.tr(),
                        style: AppTextStyles.font14Primary700
                            .copyWith(color: AppColors.background)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Main content
          Positioned.fill(
            top: 120.h,
            child: BlocBuilder<InventoryBloc, InventoryState>(
              builder: (context, state) {
                if (state is InventoryLoading) {
                  return AppLoadingWidget(
                      message: LocaleKeys.app_inventory_loading.tr());
                }

                if (state is InventoryError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            '${LocaleKeys.app_inventory_error.tr()}: ${state.message}'),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<InventoryBloc>()
                                .add(const LoadInventory());
                          },
                          child: Text(LocaleKeys.app_inventory_retry.tr()),
                        ),
                      ],
                    ),
                  );
                }

                if (state is InventoryLoaded) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                        top: 0.h,
                        bottom: 120.h, // Space for bottom navigation bar
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 16.h,
                          mainAxisExtent: 250.h,
                        ),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return GestureDetector(
                            onTap: () {
                              context.router.push(
                                InventoryProductDetailRoute(
                                  productId: item.id,
                                  name: item.name,
                                  description: item.description,
                                  price: item.price,
                                  quantity: item.quantity,
                                  unit: item.unit,
                                  imageUrl: item.imageUrl,
                                ),
                              );
                            },
                            child: InventoryItemCard(
                              imageUrl: item.imageUrl,
                              name: item.name,
                              description: item.description,
                              price: item.price,
                              quantity: item.quantity,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
