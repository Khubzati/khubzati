import '../models/search_result.dart';
import '../models/search_filter.dart';

abstract class SearchRepository {
  Future<List<SearchResult>> search({
    required String query,
    SearchFilter? filter,
    int page = 1,
    int limit = 20,
  });

  Future<List<String>> getSearchSuggestions(String query);

  Future<List<String>> getPopularSearches();

  Future<List<String>> getSearchHistory();

  Future<void> saveSearchQuery(String query);

  Future<void> clearSearchHistory();

  Future<List<String>> getCategories();

  Future<void> toggleFavorite(String resultId, bool isFavorite);
}
