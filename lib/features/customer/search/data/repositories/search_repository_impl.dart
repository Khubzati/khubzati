import 'package:injectable/injectable.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_remote_datasource.dart';
import '../../domain/models/search_result.dart';
import '../../domain/models/search_filter.dart';
import '../../domain/repositories/search_repository.dart';

@Injectable(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;
  final SearchLocalDataSource _localDataSource;

  SearchRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<List<SearchResult>> search({
    required String query,
    SearchFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Try remote search first
      final results = await _remoteDataSource.search(
        query: query,
        filter: filter,
        page: page,
        limit: limit,
      );
      
      // Save search query to history
      if (query.isNotEmpty) {
        await saveSearchQuery(query);
      }
      
      return results;
    } catch (e) {
      // Fallback to local search if remote fails
      return await _localDataSource.search(
        query: query,
        filter: filter,
        page: page,
        limit: limit,
      );
    }
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      return await _remoteDataSource.getSearchSuggestions(query);
    } catch (e) {
      return await _localDataSource.getSearchSuggestions(query);
    }
  }

  @override
  Future<List<String>> getPopularSearches() async {
    try {
      return await _remoteDataSource.getPopularSearches();
    } catch (e) {
      return await _localDataSource.getPopularSearches();
    }
  }

  @override
  Future<List<String>> getSearchHistory() async {
    return await _localDataSource.getSearchHistory();
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    await _localDataSource.saveSearchQuery(query);
  }

  @override
  Future<void> clearSearchHistory() async {
    await _localDataSource.clearSearchHistory();
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await _remoteDataSource.getCategories();
    } catch (e) {
      return await _localDataSource.getCategories();
    }
  }

  @override
  Future<void> toggleFavorite(String resultId, bool isFavorite) async {
    await _localDataSource.toggleFavorite(resultId, isFavorite);
  }
}
