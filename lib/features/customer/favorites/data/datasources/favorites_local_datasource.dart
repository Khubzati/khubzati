import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/favorite_item.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteItem>> getFavorites();
  Future<void> addToFavorites(FavoriteItem item);
  Future<void> removeFromFavorites(String itemId);
  Future<bool> isFavorite(String itemId);
  Future<void> clearAllFavorites();
  Future<void> clearFavoriteVendors();
  Future<void> clearFavoriteProducts();
}

@Injectable(as: FavoritesLocalDataSource)
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences _prefs;

  FavoritesLocalDataSourceImpl(this._prefs);

  static const String _favoritesKey = 'favorites';

  @override
  Future<List<FavoriteItem>> getFavorites() async {
    final favoritesJson = _prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList.map((json) => FavoriteItem.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> addToFavorites(FavoriteItem item) async {
    final favorites = await getFavorites();

    // Check if item already exists
    if (!favorites.any((favorite) => favorite.id == item.id)) {
      favorites.add(item);
      await _saveFavorites(favorites);
    }
  }

  @override
  Future<void> removeFromFavorites(String itemId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((favorite) => favorite.id == itemId);
    await _saveFavorites(favorites);
  }

  @override
  Future<bool> isFavorite(String itemId) async {
    final favorites = await getFavorites();
    return favorites.any((favorite) => favorite.id == itemId);
  }

  @override
  Future<void> clearAllFavorites() async {
    await _prefs.remove(_favoritesKey);
  }

  @override
  Future<void> clearFavoriteVendors() async {
    final favorites = await getFavorites();
    final filteredFavorites =
        favorites.where((item) => item.type != 'vendor').toList();
    await _saveFavorites(filteredFavorites);
  }

  @override
  Future<void> clearFavoriteProducts() async {
    final favorites = await getFavorites();
    final filteredFavorites =
        favorites.where((item) => item.type != 'product').toList();
    await _saveFavorites(filteredFavorites);
  }

  Future<void> _saveFavorites(List<FavoriteItem> favorites) async {
    final favoritesJson =
        json.encode(favorites.map((item) => item.toJson()).toList());
    await _prefs.setString(_favoritesKey, favoritesJson);
  }
}
