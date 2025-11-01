import 'package:equatable/equatable.dart';

class SearchFilter extends Equatable {
  final List<String> categories;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String? sortBy;
  final bool? isOpen;
  final String? location;

  const SearchFilter({
    this.categories = const [],
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sortBy,
    this.isOpen,
    this.location,
  });

  @override
  List<Object?> get props => [
        categories,
        minPrice,
        maxPrice,
        minRating,
        sortBy,
        isOpen,
        location,
      ];

  SearchFilter copyWith({
    List<String>? categories,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    bool? isOpen,
    String? location,
  }) {
    return SearchFilter(
      categories: categories ?? this.categories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      isOpen: isOpen ?? this.isOpen,
      location: location ?? this.location,
    );
  }

  bool get hasActiveFilters {
    return categories.isNotEmpty ||
        minPrice != null ||
        maxPrice != null ||
        minRating != null ||
        sortBy != null ||
        isOpen != null ||
        location != null;
  }

  SearchFilter clear() {
    return const SearchFilter();
  }
}
