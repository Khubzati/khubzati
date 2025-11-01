import 'package:equatable/equatable.dart';
import '../../domain/models/search_result.dart';
import '../../domain/models/search_filter.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<SearchResult> results;
  final String query;
  final SearchFilter filter;
  final bool hasMore;
  final List<String> suggestions;
  final List<String> popularSearches;
  final List<String> searchHistory;
  final List<String> categories;

  const SearchLoaded({
    required this.results,
    required this.query,
    required this.filter,
    required this.hasMore,
    required this.suggestions,
    required this.popularSearches,
    required this.searchHistory,
    required this.categories,
  });

  @override
  List<Object?> get props => [
        results,
        query,
        filter,
        hasMore,
        suggestions,
        popularSearches,
        searchHistory,
        categories,
      ];

  SearchLoaded copyWith({
    List<SearchResult>? results,
    String? query,
    SearchFilter? filter,
    bool? hasMore,
    List<String>? suggestions,
    List<String>? popularSearches,
    List<String>? searchHistory,
    List<String>? categories,
  }) {
    return SearchLoaded(
      results: results ?? this.results,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
      suggestions: suggestions ?? this.suggestions,
      popularSearches: popularSearches ?? this.popularSearches,
      searchHistory: searchHistory ?? this.searchHistory,
      categories: categories ?? this.categories,
    );
  }
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchSuggestionsLoaded extends SearchState {
  final List<String> suggestions;

  const SearchSuggestionsLoaded(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}

class SearchHistoryLoaded extends SearchState {
  final List<String> searchHistory;

  const SearchHistoryLoaded(this.searchHistory);

  @override
  List<Object> get props => [searchHistory];
}

class CategoriesLoaded extends SearchState {
  final List<String> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}
