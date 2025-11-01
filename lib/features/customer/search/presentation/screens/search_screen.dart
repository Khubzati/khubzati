import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/extenstions/context.dart';
import 'package:khubzati/core/widgets/shared/app_loading_widget.dart';

import '../blocs/search_bloc.dart';
import '../blocs/search_event.dart';
import '../blocs/search_state.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_results_list.dart';
import '../widgets/search_suggestions_list.dart';
import '../widgets/search_filters_bottom_sheet.dart';
import '../widgets/search_empty_state.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<SearchBloc>().add(const SearchResultsLoaded());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onSearchChanged: (query) {
          context.read<SearchBloc>().add(SearchQueryChanged(query));
        },
        onSearchSubmitted: (query) {
          context.read<SearchBloc>().add(SearchSubmitted(query));
        },
        onFiltersPressed: () {
          _showFiltersBottomSheet();
        },
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const AppLoadingWidget(
              message: 'Searching...',
            );
          }

          if (state is SearchError) {
            return _buildErrorState(context, state.message);
          }

          if (state is SearchLoaded) {
            return _buildSearchContent(context, state);
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
              context.read<SearchBloc>().add(const SearchResultsLoaded());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context, SearchLoaded state) {
    final hasQuery = state.query.isNotEmpty;
    final hasResults = state.results.isNotEmpty;

    if (!hasQuery) {
      return SearchSuggestionsList(
        popularSearches: state.popularSearches,
        searchHistory: state.searchHistory,
        onSuggestionTap: (suggestion) {
          _searchController.text = suggestion;
          context.read<SearchBloc>().add(SearchSubmitted(suggestion));
        },
        onHistoryCleared: () {
          context.read<SearchBloc>().add(const SearchHistoryCleared());
        },
      );
    }

    if (hasQuery && !hasResults) {
      return SearchEmptyState(
        query: state.query,
        onRetry: () {
          context.read<SearchBloc>().add(SearchSubmitted(state.query));
        },
      );
    }

    return SearchResultsList(
      results: state.results,
      query: state.query,
      hasMore: state.hasMore,
      onResultTap: (resultId) {
        context.read<SearchBloc>().add(SearchResultTapped(resultId));
        // TODO: Navigate to result details
      },
      onFavoriteToggle: (resultId, isFavorite) {
        context.read<SearchBloc>().add(FavoriteToggled(resultId, isFavorite));
      },
      onLoadMore: () {
        // TODO: Implement pagination
      },
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchFiltersBottomSheet(
        onFiltersApplied: (filter) {
          context.read<SearchBloc>().add(SearchFiltersChanged(filter));
        },
        onFiltersCleared: () {
          context.read<SearchBloc>().add(const SearchFiltersCleared());
        },
      ),
    );
  }
}
