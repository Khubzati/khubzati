import 'package:injectable/injectable.dart';
import '../datasources/favorites_local_datasource.dart';
import '../../domain/models/favorite_item.dart';
import '../../domain/repositories/favorites_repository.dart';

@Injectable(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesRepositoryImpl(this._localDataSource);

  @override
  Future<List<FavoriteItem>> getFavorites() async {
    return await _localDataSource.getFavorites();
  }

  @override
  Future<List<FavoriteItem>> getFavoriteVendors() async {
    final favorites = await _localDataSource.getFavorites();
    return favorites.where((item) => item.type == 'vendor').toList();
  }

  @override
  Future<List<FavoriteItem>> getFavoriteProducts() async {
    final favorites = await _localDataSource.getFavorites();
    return favorites.where((item) => item.type == 'product').toList();
  }

  @override
  Future<void> addToFavorites(FavoriteItem item) async {
    await _localDataSource.addToFavorites(item);
  }

  @override
  Future<void> removeFromFavorites(String itemId) async {
    await _localDataSource.removeFromFavorites(itemId);
  }

  @override
  Future<bool> isFavorite(String itemId) async {
    return await _localDataSource.isFavorite(itemId);
  }

  @override
  Future<void> clearAllFavorites() async {
    await _localDataSource.clearAllFavorites();
  }

  @override
  Future<void> clearFavoriteVendors() async {
    await _localDataSource.clearFavoriteVendors();
  }

  @override
  Future<void> clearFavoriteProducts() async {
    await _localDataSource.clearFavoriteProducts();
  }
}
