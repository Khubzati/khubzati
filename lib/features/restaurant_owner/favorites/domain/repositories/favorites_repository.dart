import '../models/favorite_product.dart';
import '../models/favorite_bakery.dart';

abstract class RestaurantOwnerFavoritesRepository {
  Future<List<FavoriteProduct>> getFavoriteProducts();
  Future<List<FavoriteBakery>> getFavoriteBakeries();
  Future<void> addFavoriteProduct(FavoriteProduct product);
  Future<void> addFavoriteBakery(FavoriteBakery bakery);
  Future<void> removeFavoriteProduct(String productId);
  Future<void> removeFavoriteBakery(String bakeryId);
  Future<bool> isProductFavorite(String productId);
  Future<bool> isBakeryFavorite(String bakeryId);
  Future<void> clearAllFavorites();
  Future<void> clearFavoriteProducts();
  Future<void> clearFavoriteBakeries();
}

