import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/models/search_filter.dart';
import 'search_event.dart';
import 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;

  SearchBloc(this._searchRepository) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchFiltersChanged>(_onSearchFiltersChanged);
    on<SearchFiltersCleared>(_onSearchFiltersCleared);
    on<SearchResultsLoaded>(_onSearchResultsLoaded);
    on<SearchSuggestionsRequested>(_onSearchSuggestionsRequested);
    on<PopularSearchesRequested>(_onPopularSearchesRequested);
    on<SearchHistoryRequested>(_onSearchHistoryRequested);
    on<SearchHistoryCleared>(_onSearchHistoryCleared);
    on<CategoriesRequested>(_onCategoriesRequested);
    on<FavoriteToggled>(_onFavoriteToggled);
    on<SearchResultTapped>(_onSearchResultTapped);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(currentState.copyWith(query: event.query));
    }
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading());

    try {
      final currentState = state;
      SearchFilter filter = const SearchFilter();
      
      if (currentState is SearchLoaded) {
        filter = currentState.filter;
      }

      final results = await _searchRepository.search(
        query: event.query,
        filter: filter,
      );

      final suggestions = await _searchRepository.getSearchSuggestions(event.query);
      final popularSearches = await _searchRepository.getPopularSearches();
      final searchHistory = await _searchRepository.getSearchHistory();
      final categories = await _searchRepository.getCategories();

      emit(SearchLoaded(
        results: results,
        query: event.query,
        filter: filter,
        hasMore: results.length >= 20,
        suggestions: suggestions,
        popularSearches: popularSearches,
        searchHistory: searchHistory,
        categories: categories,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchFiltersChanged(
    SearchFiltersChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      
      try {
        final results = await _searchRepository.search(
          query: currentState.query,
          filter: event.filter,
        );

        emit(currentState.copyWith(
          results: results,
          filter: event.filter,
          hasMore: results.length >= 20,
        ));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    }
  }

  Future<void> _onSearchFiltersCleared(
    SearchFiltersCleared event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      const clearedFilter = SearchFilter();
      
      try {
        final results = await _searchRepository.search(
          query: currentState.query,
          filter: clearedFilter,
        );

        emit(currentState.copyWith(
          results: results,
          filter: clearedFilter,
          hasMore: results.length >= 20,
        ));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    }
  }

  Future<void> _onSearchResultsLoaded(
    SearchResultsLoaded event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading());

    try {
      final popularSearches = await _searchRepository.getPopularSearches();
      final searchHistory = await _searchRepository.getSearchHistory();
      final categories = await _searchRepository.getCategories();

      emit(SearchLoaded(
        results: const [],
        query: '',
        filter: const SearchFilter(),
        hasMore: false,
        suggestions: const [],
        popularSearches: popularSearches,
        searchHistory: searchHistory,
        categories: categories,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchSuggestionsRequested(
    SearchSuggestionsRequested event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final suggestions = await _searchRepository.getSearchSuggestions(event.query);
      emit(SearchSuggestionsLoaded(suggestions));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onPopularSearchesRequested(
    PopularSearchesRequested event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final popularSearches = await _searchRepository.getPopularSearches();
      emit(SearchSuggestionsLoaded(popularSearches));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchHistoryRequested(
    SearchHistoryRequested event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final searchHistory = await _searchRepository.getSearchHistory();
      emit(SearchHistoryLoaded(searchHistory));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchHistoryCleared(
    SearchHistoryCleared event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await _searchRepository.clearSearchHistory();
      emit(const SearchHistoryLoaded([]));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onCategoriesRequested(
    CategoriesRequested event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final categories = await _searchRepository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onFavoriteToggled(
    FavoriteToggled event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await _searchRepository.toggleFavorite(event.resultId, event.isFavorite);
      
      if (state is SearchLoaded) {
        final currentState = state as SearchLoaded;
        final updatedResults = currentState.results.map((result) {
          if (result.id == event.resultId) {
            return result.copyWith(isFavorite: event.isFavorite);
          }
          return result;
        }).toList();

        emit(currentState.copyWith(results: updatedResults));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchResultTapped(
    SearchResultTapped event,
    Emitter<SearchState> emit,
  ) async {
    // Handle navigation to result details
    // This would typically be handled by the UI layer
  }
}
