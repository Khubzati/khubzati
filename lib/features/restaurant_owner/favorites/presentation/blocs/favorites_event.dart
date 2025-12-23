import 'package:equatable/equatable.dart';

abstract class RestaurantOwnerFavoritesEvent extends Equatable {
  const RestaurantOwnerFavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends RestaurantOwnerFavoritesEvent {
  const LoadFavorites();
}

class SwitchTab extends RestaurantOwnerFavoritesEvent {
  final String tab; // 'items' or 'bakeries'

  const SwitchTab(this.tab);

  @override
  List<Object?> get props => [tab];
}

class SearchBakeries extends RestaurantOwnerFavoritesEvent {
  final String query;

  const SearchBakeries(this.query);

  @override
  List<Object?> get props => [query];
}

class RemoveFavoriteProduct extends RestaurantOwnerFavoritesEvent {
  final String productId;

  const RemoveFavoriteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RemoveFavoriteBakery extends RestaurantOwnerFavoritesEvent {
  final String bakeryId;

  const RemoveFavoriteBakery(this.bakeryId);

  @override
  List<Object?> get props => [bakeryId];
}

class ClearAllFavorites extends RestaurantOwnerFavoritesEvent {
  const ClearAllFavorites();
}

class ClearFavoriteProducts extends RestaurantOwnerFavoritesEvent {
  const ClearFavoriteProducts();
}

class ClearFavoriteBakeries extends RestaurantOwnerFavoritesEvent {
  const ClearFavoriteBakeries();
}
