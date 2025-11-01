import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';
import '../blocs/favorites_event.dart' as events;
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import '../blocs/favorites_bloc.dart';
import '../blocs/favorites_state.dart' as states;
import '../widgets/favorites_app_bar.dart';
import '../widgets/favorites_filter_tabs.dart';
import '../widgets/favorites_list.dart';
import '../widgets/favorites_empty_state.dart';

@RoutePage()
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(const events.FavoritesLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FavoritesAppBar(
        onClearAll: () {
          _showClearAllDialog();
        },
      ),
      body: BlocBuilder<FavoritesBloc, states.FavoritesState>(
        builder: (context, state) {
          if (state is states.FavoritesLoading) {
            return const AppLoadingWidget(
              message: 'Loading favorites...',
            );
          }

          if (state is states.FavoritesError) {
            return _buildErrorState(context, state.message);
          }

          if (state is states.FavoritesEmpty) {
            return FavoritesEmptyState(filter: state.filter);
          }

          if (state is states.FavoritesLoaded) {
            return Column(
              children: [
                FavoritesFilterTabs(
                  currentFilter: state.currentFilter,
                  onFilterChanged: (filter) {
                    context
                        .read<FavoritesBloc>()
                        .add(events.FavoritesFilterChanged(filter));
                  },
                ),
                Expanded(
                  child: FavoritesList(
                    favorites: state.filteredFavorites,
                    onItemTap: (itemId) {
                      context
                          .read<FavoritesBloc>()
                          .add(events.FavoriteItemTapped(itemId));
                      // TODO: Navigate to item details
                    },
                    onItemRemoved: (itemId) {
                      context
                          .read<FavoritesBloc>()
                          .add(events.FavoriteItemRemoved(itemId));
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.theme.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<FavoritesBloc>().add(const events.FavoritesLoaded());
            },
            child: Text(LocaleKeys.app_common_retry.tr()),
          ),
        ],
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
              context
                  .read<FavoritesBloc>()
                  .add(const events.AllFavoritesCleared());
            },
            child: Text(LocaleKeys.app_common_confirm.tr()),
          ),
        ],
      ),
    );
  }
}
