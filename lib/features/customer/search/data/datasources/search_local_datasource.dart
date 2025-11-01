import 'package:injectable/injectable.dart';
import 'package:khubzati/features/customer/search/domain/models/search_filter.dart';
import 'package:khubzati/features/customer/search/domain/models/search_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class SearchLocalDataSource {
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

@Injectable(as: SearchLocalDataSource)
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final SharedPreferences _prefs;

  SearchLocalDataSourceImpl(this._prefs);

  static const String _searchHistoryKey = 'search_history';
  static const String _favoritesKey = 'favorites';

  @override
  Future<List<SearchResult>> search({
    required String query,
    SearchFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    // For local search, we'll return cached results or empty list
    // In a real app, this might search through cached data
    await Future.delayed(const Duration(milliseconds: 200));
    return [];
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    final history = await getSearchHistory();
    return history
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<String>> getPopularSearches() async {
    // Return cached popular searches or default ones
    return [
      'Fresh bread',
      'Arabic bread',
      'Toast bread',
      'Bakery near me',
    ];
  }

  @override
  Future<List<String>> getSearchHistory() async {
    final historyJson = _prefs.getString(_searchHistoryKey);
    if (historyJson != null) {
      final List<dynamic> history = json.decode(historyJson);
      return history.cast<String>();
    }
    return [];
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    final history = await getSearchHistory();

    // Remove if already exists to avoid duplicates
    history.remove(query);

    // Add to beginning
    history.insert(0, query);

    // Keep only last 20 searches
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }

    await _prefs.setString(_searchHistoryKey, json.encode(history));
  }

  @override
  Future<void> clearSearchHistory() async {
    await _prefs.remove(_searchHistoryKey);
  }

  @override
  Future<List<String>> getCategories() async {
    return [
      'Bakery',
      'Restaurant',
      'Fast Food',
      'Desserts',
      'Beverages',
      'Healthy Food',
    ];
  }

  @override
  Future<void> toggleFavorite(String resultId, bool isFavorite) async {
    final favoritesJson = _prefs.getString(_favoritesKey);
    Set<String> favorites = {};

    if (favoritesJson != null) {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      favorites = favoritesList.cast<String>().toSet();
    }

    if (isFavorite) {
      favorites.add(resultId);
    } else {
      favorites.remove(resultId);
    }

    await _prefs.setString(_favoritesKey, json.encode(favorites.toList()));
  }
}
