import 'package:equatable/equatable.dart';
import '../../domain/models/favorite_item.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesLoaded extends FavoritesEvent {
  const FavoritesLoaded();
}

class FavoritesFilterChanged extends FavoritesEvent {
  final String filter; // 'all', 'vendors', 'products'

  const FavoritesFilterChanged(this.filter);

  @override
  List<Object> get props => [filter];
}

class FavoriteItemRemoved extends FavoritesEvent {
  final String itemId;

  const FavoriteItemRemoved(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class FavoriteItemAdded extends FavoritesEvent {
  final FavoriteItem item;

  const FavoriteItemAdded(this.item);

  @override
  List<Object> get props => [item];
}

class AllFavoritesCleared extends FavoritesEvent {
  const AllFavoritesCleared();
}

class FavoriteVendorsCleared extends FavoritesEvent {
  const FavoriteVendorsCleared();
}

class FavoriteProductsCleared extends FavoritesEvent {
  const FavoriteProductsCleared();
}

class FavoriteItemTapped extends FavoritesEvent {
  final String itemId;

  const FavoriteItemTapped(this.itemId);

  @override
  List<Object> get props => [itemId];
}
