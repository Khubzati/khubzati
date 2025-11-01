import '../models/favorite_item.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteItem>> getFavorites();
  Future<List<FavoriteItem>> getFavoriteVendors();
  Future<List<FavoriteItem>> getFavoriteProducts();
  Future<void> addToFavorites(FavoriteItem item);
  Future<void> removeFromFavorites(String itemId);
  Future<bool> isFavorite(String itemId);
  Future<void> clearAllFavorites();
  Future<void> clearFavoriteVendors();
  Future<void> clearFavoriteProducts();
}
