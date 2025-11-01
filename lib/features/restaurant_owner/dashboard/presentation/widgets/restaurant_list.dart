import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/empty_state_widget.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_bloc.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_event.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_state.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/presentation/widgets/restaurant_card.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantOwnerHomeBloc, RestaurantOwnerHomeState>(
      builder: (context, state) {
        if (state is RestaurantOwnerHomeLoading) {
          return const Center(
            child: AppLoadingWidget(),
          );
        }

        if (state is RestaurantOwnerHomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16.h),
                Text(
                  state.message,
                  style: AppTextStyles.font16textDarkBrownBold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<RestaurantOwnerHomeBloc>().add(
                          const LoadRestaurantOwnerHome(),
                        );
                  },
                  child: Text(LocaleKeys.app_common_retry.tr()),
                ),
              ],
            ),
          );
        }

        if (state is RestaurantOwnerHomeLoaded) {
          if (state.restaurants.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.restaurant,
              title: LocaleKeys.app_restaurant_owner_home_no_restaurants.tr(),
              subtitle: LocaleKeys
                  .app_restaurant_owner_home_no_restaurants_subtitle
                  .tr(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<RestaurantOwnerHomeBloc>().add(
                    const RefreshRestaurants(),
                  );
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = state.restaurants[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  onFavoriteToggle: () {
                    context.read<RestaurantOwnerHomeBloc>().add(
                          ToggleFavorite(restaurant.id),
                        );
                  },
                  onTap: () {
                    // TODO: Navigate to restaurant details
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
