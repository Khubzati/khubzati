import '../../domain/models/search_filter.dart' as domain;

class SearchFilterModel extends domain.SearchFilter {
  const SearchFilterModel({
    super.categories = const [],
    super.minPrice,
    super.maxPrice,
    super.minRating,
    super.sortBy,
    super.isOpen,
    super.location,
  });

  factory SearchFilterModel.fromJson(Map<String, dynamic> json) {
    return SearchFilterModel(
      categories: List<String>.from(json['categories'] ?? []),
      minPrice: json['min_price']?.toDouble(),
      maxPrice: json['max_price']?.toDouble(),
      minRating: json['min_rating']?.toDouble(),
      sortBy: json['sort_by'],
      isOpen: json['is_open'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'min_price': minPrice,
      'max_price': maxPrice,
      'min_rating': minRating,
      'sort_by': sortBy,
      'is_open': isOpen,
      'location': location,
    };
  }

  factory SearchFilterModel.fromDomain(domain.SearchFilter filter) {
    return SearchFilterModel(
      categories: filter.categories,
      minPrice: filter.minPrice,
      maxPrice: filter.maxPrice,
      minRating: filter.minRating,
      sortBy: filter.sortBy,
      isOpen: filter.isOpen,
      location: filter.location,
    );
  }

  domain.SearchFilter toDomain() {
    return domain.SearchFilter(
      categories: categories,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      sortBy: sortBy,
      isOpen: isOpen,
      location: location,
    );
  }
}
