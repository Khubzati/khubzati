import 'package:equatable/equatable.dart';
import '../../domain/models/favorite_item.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItem> allFavorites;
  final List<FavoriteItem> favoriteVendors;
  final List<FavoriteItem> favoriteProducts;
  final String currentFilter;
  final List<FavoriteItem> filteredFavorites;

  const FavoritesLoaded({
    required this.allFavorites,
    required this.favoriteVendors,
    required this.favoriteProducts,
    required this.currentFilter,
    required this.filteredFavorites,
  });

  @override
  List<Object?> get props => [
        allFavorites,
        favoriteVendors,
        favoriteProducts,
        currentFilter,
        filteredFavorites,
      ];

  FavoritesLoaded copyWith({
    List<FavoriteItem>? allFavorites,
    List<FavoriteItem>? favoriteVendors,
    List<FavoriteItem>? favoriteProducts,
    String? currentFilter,
    List<FavoriteItem>? filteredFavorites,
  }) {
    return FavoritesLoaded(
      allFavorites: allFavorites ?? this.allFavorites,
      favoriteVendors: favoriteVendors ?? this.favoriteVendors,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      currentFilter: currentFilter ?? this.currentFilter,
      filteredFavorites: filteredFavorites ?? this.filteredFavorites,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoritesEmpty extends FavoritesState {
  final String filter;

  const FavoritesEmpty(this.filter);

  @override
  List<Object> get props => [filter];
}
