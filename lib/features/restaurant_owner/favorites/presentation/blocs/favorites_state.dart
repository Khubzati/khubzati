import 'package:equatable/equatable.dart';
import '../../domain/models/favorite_product.dart';
import '../../domain/models/favorite_bakery.dart';

abstract class RestaurantOwnerFavoritesState extends Equatable {
  const RestaurantOwnerFavoritesState();

  @override
  List<Object?> get props => [];
}

class RestaurantOwnerFavoritesInitial extends RestaurantOwnerFavoritesState {
  const RestaurantOwnerFavoritesInitial();
}

class RestaurantOwnerFavoritesLoading extends RestaurantOwnerFavoritesState {
  const RestaurantOwnerFavoritesLoading();
}

class RestaurantOwnerFavoritesLoaded extends RestaurantOwnerFavoritesState {
  final List<FavoriteProduct> favoriteProducts;
  final List<FavoriteBakery> favoriteBakeries;
  final String currentTab; // 'items' or 'bakeries'
  final String searchQuery;
  final List<FavoriteBakery> filteredBakeries;

  const RestaurantOwnerFavoritesLoaded({
    required this.favoriteProducts,
    required this.favoriteBakeries,
    this.currentTab = 'items',
    this.searchQuery = '',
    List<FavoriteBakery>? filteredBakeries,
  }) : filteredBakeries = filteredBakeries ?? favoriteBakeries;

  @override
  List<Object?> get props => [
        favoriteProducts,
        favoriteBakeries,
        currentTab,
        searchQuery,
        filteredBakeries,
      ];

  RestaurantOwnerFavoritesLoaded copyWith({
    List<FavoriteProduct>? favoriteProducts,
    List<FavoriteBakery>? favoriteBakeries,
    String? currentTab,
    String? searchQuery,
    List<FavoriteBakery>? filteredBakeries,
  }) {
    return RestaurantOwnerFavoritesLoaded(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      favoriteBakeries: favoriteBakeries ?? this.favoriteBakeries,
      currentTab: currentTab ?? this.currentTab,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredBakeries: filteredBakeries ?? this.filteredBakeries,
    );
  }
}

class RestaurantOwnerFavoritesError extends RestaurantOwnerFavoritesState {
  final String message;

  const RestaurantOwnerFavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

class RestaurantOwnerFavoritesEmpty extends RestaurantOwnerFavoritesState {
  final String tab; // 'items' or 'bakeries'

  const RestaurantOwnerFavoritesEmpty(this.tab);

  @override
  List<Object?> get props => [tab];
}

