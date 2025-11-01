import 'package:equatable/equatable.dart';
import '../../domain/models/search_filter.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SearchSubmitted extends SearchEvent {
  final String query;

  const SearchSubmitted(this.query);

  @override
  List<Object> get props => [query];
}

class SearchFiltersChanged extends SearchEvent {
  final SearchFilter filter;

  const SearchFiltersChanged(this.filter);

  @override
  List<Object> get props => [filter];
}

class SearchFiltersCleared extends SearchEvent {
  const SearchFiltersCleared();
}

class SearchResultsLoaded extends SearchEvent {
  const SearchResultsLoaded();
}

class SearchSuggestionsRequested extends SearchEvent {
  final String query;

  const SearchSuggestionsRequested(this.query);

  @override
  List<Object> get props => [query];
}

class PopularSearchesRequested extends SearchEvent {
  const PopularSearchesRequested();
}

class SearchHistoryRequested extends SearchEvent {
  const SearchHistoryRequested();
}

class SearchHistoryCleared extends SearchEvent {
  const SearchHistoryCleared();
}

class CategoriesRequested extends SearchEvent {
  const CategoriesRequested();
}

class FavoriteToggled extends SearchEvent {
  final String resultId;
  final bool isFavorite;

  const FavoriteToggled(this.resultId, this.isFavorite);

  @override
  List<Object> get props => [resultId, isFavorite];
}

class SearchResultTapped extends SearchEvent {
  final String resultId;

  const SearchResultTapped(this.resultId);

  @override
  List<Object> get props => [resultId];
}
