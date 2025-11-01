import 'package:injectable/injectable.dart';
import 'package:khubzati/features/customer/search/domain/models/search_filter.dart';
import 'package:khubzati/features/customer/search/domain/models/search_result.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResult>> search({
    required String query,
    SearchFilter? filter,
    int page = 1,
    int limit = 20,
  });

  Future<List<String>> getSearchSuggestions(String query);

  Future<List<String>> getPopularSearches();

  Future<List<String>> getCategories();
}

@Injectable(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  // TODO: Inject HTTP client or API service
  // final ApiService _apiService;

  @override
  Future<List<SearchResult>> search({
    required String query,
    SearchFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    // TODO: Implement actual API call
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay

    // Mock data for now
    return _getMockSearchResults(query, filter);
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock suggestions
    return [
      'Fresh bread',
      'Arabic bread',
      'Toast bread',
      'Pita bread',
      'Bakery near me',
      'Restaurant delivery',
    ]
        .where((suggestion) =>
            suggestion.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<String>> getPopularSearches() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      'Fresh bread',
      'Arabic bread',
      'Toast bread',
      'Bakery near me',
      'Restaurant delivery',
      'Pizza delivery',
      'Fast food',
    ];
  }

  @override
  Future<List<String>> getCategories() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      'Bakery',
      'Restaurant',
      'Fast Food',
      'Desserts',
      'Beverages',
      'Healthy Food',
    ];
  }

  List<SearchResult> _getMockSearchResults(String query, SearchFilter? filter) {
    final mockResults = [
      const SearchResult(
        id: '1',
        name: 'Al-Sarwat Bakery',
        description: 'Fresh Arabic bread and pastries',
        image: 'https://example.com/bakery1.jpg',
        type: 'vendor',
        rating: 4.5,
        category: 'Bakery',
        isFavorite: false,
      ),
      const SearchResult(
        id: '2',
        name: 'Fresh Toast Bread',
        description: 'Soft and fresh toast bread',
        image: 'https://example.com/toast.jpg',
        type: 'product',
        rating: 4.2,
        price: 2.50,
        category: 'Bakery',
        isFavorite: true,
      ),
      const SearchResult(
        id: '3',
        name: 'Al-Madina Restaurant',
        description: 'Traditional Arabic cuisine',
        image: 'https://example.com/restaurant1.jpg',
        type: 'vendor',
        rating: 4.8,
        category: 'Restaurant',
        isFavorite: false,
      ),
      const SearchResult(
        id: '4',
        name: 'Arabic Bread',
        description: 'Traditional Arabic bread',
        image: 'https://example.com/arabic-bread.jpg',
        type: 'product',
        rating: 4.6,
        price: 1.50,
        category: 'Bakery',
        isFavorite: false,
      ),
    ];

    // Filter results based on query
    if (query.isEmpty) return mockResults;

    return mockResults
        .where((result) =>
            result.name.toLowerCase().contains(query.toLowerCase()) ||
            result.description.toLowerCase().contains(query.toLowerCase()) ||
            result.category?.toLowerCase().contains(query.toLowerCase()) ==
                true)
        .toList();
  }
}
