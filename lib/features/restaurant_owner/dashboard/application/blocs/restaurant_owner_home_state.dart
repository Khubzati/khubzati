import 'package:equatable/equatable.dart';

class RestaurantOwnerHomeState extends Equatable {
  const RestaurantOwnerHomeState();

  @override
  List<Object?> get props => [];
}

class RestaurantOwnerHomeInitial extends RestaurantOwnerHomeState {
  const RestaurantOwnerHomeInitial();
}

class RestaurantOwnerHomeLoading extends RestaurantOwnerHomeState {
  const RestaurantOwnerHomeLoading();
}

class RestaurantOwnerHomeLoaded extends RestaurantOwnerHomeState {
  final List<RestaurantItem> restaurants;
  final String searchQuery;
  final String selectedFilter;
  final Set<String> favoriteIds;

  const RestaurantOwnerHomeLoaded({
    required this.restaurants,
    this.searchQuery = '',
    this.selectedFilter = '',
    this.favoriteIds = const {},
  });

  @override
  List<Object?> get props =>
      [restaurants, searchQuery, selectedFilter, favoriteIds];

  RestaurantOwnerHomeLoaded copyWith({
    List<RestaurantItem>? restaurants,
    String? searchQuery,
    String? selectedFilter,
    Set<String>? favoriteIds,
  }) {
    return RestaurantOwnerHomeLoaded(
      restaurants: restaurants ?? this.restaurants,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

class RestaurantOwnerHomeError extends RestaurantOwnerHomeState {
  final String message;

  const RestaurantOwnerHomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class RestaurantItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final String imageUrl;
  final bool isFavorite;

  const RestaurantItem({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.imageUrl,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        rating,
        reviewCount,
        deliveryTime,
        imageUrl,
        isFavorite,
      ];

  RestaurantItem copyWith({
    String? id,
    String? name,
    String? description,
    double? rating,
    int? reviewCount,
    String? deliveryTime,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return RestaurantItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
