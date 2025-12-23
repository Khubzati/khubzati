import 'package:injectable/injectable.dart';
import '../datasources/favorites_local_datasource.dart';
import '../../domain/models/favorite_product.dart';
import '../../domain/models/favorite_bakery.dart';
import '../../domain/repositories/favorites_repository.dart';

@Injectable(as: RestaurantOwnerFavoritesRepository)
class RestaurantOwnerFavoritesRepositoryImpl
    implements RestaurantOwnerFavoritesRepository {
  final RestaurantOwnerFavoritesLocalDataSource _localDataSource;

  RestaurantOwnerFavoritesRepositoryImpl(this._localDataSource);

  @override
  Future<List<FavoriteProduct>> getFavoriteProducts() async {
    return await _localDataSource.getFavoriteProducts();
  }

  @override
  Future<List<FavoriteBakery>> getFavoriteBakeries() async {
    return await _localDataSource.getFavoriteBakeries();
  }

  @override
  Future<void> addFavoriteProduct(FavoriteProduct product) async {
    await _localDataSource.addFavoriteProduct(product);
  }

  @override
  Future<void> addFavoriteBakery(FavoriteBakery bakery) async {
    await _localDataSource.addFavoriteBakery(bakery);
  }

  @override
  Future<void> removeFavoriteProduct(String productId) async {
    await _localDataSource.removeFavoriteProduct(productId);
  }

  @override
  Future<void> removeFavoriteBakery(String bakeryId) async {
    await _localDataSource.removeFavoriteBakery(bakeryId);
  }

  @override
  Future<bool> isProductFavorite(String productId) async {
    return await _localDataSource.isProductFavorite(productId);
  }

  @override
  Future<bool> isBakeryFavorite(String bakeryId) async {
    return await _localDataSource.isBakeryFavorite(bakeryId);
  }

  @override
  Future<void> clearAllFavorites() async {
    await _localDataSource.clearAllFavorites();
  }

  @override
  Future<void> clearFavoriteProducts() async {
    await _localDataSource.clearFavoriteProducts();
  }

  @override
  Future<void> clearFavoriteBakeries() async {
    await _localDataSource.clearFavoriteBakeries();
  }
}

