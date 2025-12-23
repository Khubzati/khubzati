import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:khubzati/core/di/injection.dart';
import '../blocs/favorites_bloc.dart';
import '../blocs/favorites_event.dart' as events;
import '../blocs/favorites_state.dart' as states;
import '../widgets/favorites_app_bar.dart';
import '../widgets/favorites_filter_tabs.dart';
import '../widgets/favorite_products_grid.dart';
import '../widgets/favorite_bakeries_list.dart';
import '../widgets/bakeries_search_bar.dart';

@RoutePage()
class RestaurantOwnerFavoritesScreen extends StatefulWidget {
  const RestaurantOwnerFavoritesScreen({super.key});

  @override
  State<RestaurantOwnerFavoritesScreen> createState() =>
      _RestaurantOwnerFavoritesScreenState();
}

class _RestaurantOwnerFavoritesScreenState
    extends State<RestaurantOwnerFavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RestaurantOwnerFavoritesBloc>()
        ..add(const events.LoadFavorites()),
      child: Scaffold(
        backgroundColor: AppColors.secondaryLightCream,
        appBar: RestaurantOwnerFavoritesAppBar(
          onClearAll: () => _showClearAllDialog(),
        ),
        body: BlocBuilder<RestaurantOwnerFavoritesBloc,
            states.RestaurantOwnerFavoritesState>(
          builder: (context, state) {
            if (state is states.RestaurantOwnerFavoritesLoading) {
              return const AppLoadingWidget(
                message: 'Loading favorites...',
              );
            }

            if (state is states.RestaurantOwnerFavoritesError) {
              return _buildErrorState(context, state.message);
            }

            if (state is states.RestaurantOwnerFavoritesEmpty) {
              return _buildEmptyState(context, state.tab);
            }

            if (state is states.RestaurantOwnerFavoritesLoaded) {
              return Column(
                children: [
                  RestaurantOwnerFavoritesFilterTabs(
                    currentTab: state.currentTab,
                    onTabChanged: (tab) {
                      context.read<RestaurantOwnerFavoritesBloc>().add(
                            events.SwitchTab(tab),
                          );
                      if (tab == 'items') {
                        _searchController.clear();
                      }
                    },
                  ),
                  Expanded(
                    child: state.currentTab == 'items'
                        ? FavoriteProductsGrid(
                            products: state.favoriteProducts,
                            onProductTap: (productId) {
                              // TODO: Navigate to product details
                            },
                            onCartTap: (productId) {
                              // TODO: Add to cart
                            },
                            onFavoriteToggle: (productId) {
                              context.read<RestaurantOwnerFavoritesBloc>().add(
                                    events.RemoveFavoriteProduct(productId),
                                  );
                            },
                          )
                        : Column(
                            children: [
                              BakeriesSearchBar(
                                controller: _searchController,
                                onSearchChanged: (query) {
                                  context
                                      .read<RestaurantOwnerFavoritesBloc>()
                                      .add(
                                        events.SearchBakeries(query),
                                      );
                                },
                              ),
                              Expanded(
                                child: FavoriteBakeriesList(
                                  bakeries: state.filteredBakeries,
                                  onBakeryTap: (bakeryId) {
                                    // TODO: Navigate to bakery details
                                  },
                                  onFavoriteToggle: (bakeryId) {
                                    context
                                        .read<RestaurantOwnerFavoritesBloc>()
                                        .add(
                                          events.RemoveFavoriteBakery(bakeryId),
                                        );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.primaryBurntOrange,
            ),
            16.verticalSpace,
            Text(
              message,
              style: AppTextStyles.font16textDarkBrownBold,
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            ElevatedButton(
              onPressed: () {
                context.read<RestaurantOwnerFavoritesBloc>().add(
                      const events.LoadFavorites(),
                    );
              },
              child: Text(LocaleKeys.app_common_retry.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String tab) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tab == 'items' ? Icons.favorite_border : Icons.store_outlined,
              size: 80.sp,
              color: AppColors.textDarkBrown.withOpacity(0.4),
            ),
            24.verticalSpace,
            Text(
              tab == 'items'
                  ? LocaleKeys.app_restaurant_owner_favorites_empty_items_title
                      .tr()
                  : LocaleKeys
                      .app_restaurant_owner_favorites_empty_bakeries_title
                      .tr(),
              style: AppTextStyles.font24Textbold,
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            Text(
              tab == 'items'
                  ? LocaleKeys
                      .app_restaurant_owner_favorites_empty_items_subtitle
                      .tr()
                  : LocaleKeys
                      .app_restaurant_owner_favorites_empty_bakeries_subtitle
                      .tr(),
              style: AppTextStyles.font14TextW400OP8,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.app_favorites_clear_all_title.tr()),
        content: Text(LocaleKeys.app_favorites_clear_all_message.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.app_common_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RestaurantOwnerFavoritesBloc>().add(
                    const events.ClearAllFavorites(),
                  );
            },
            child: Text(LocaleKeys.app_common_confirm.tr()),
          ),
        ],
      ),
    );
  }
}
