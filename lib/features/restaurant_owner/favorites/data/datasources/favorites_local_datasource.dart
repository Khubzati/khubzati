import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/favorite_product.dart';
import '../../domain/models/favorite_bakery.dart';

abstract class RestaurantOwnerFavoritesLocalDataSource {
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

@Injectable(as: RestaurantOwnerFavoritesLocalDataSource)
class RestaurantOwnerFavoritesLocalDataSourceImpl
    implements RestaurantOwnerFavoritesLocalDataSource {
  final SharedPreferences _prefs;

  RestaurantOwnerFavoritesLocalDataSourceImpl(this._prefs);

  static const String _favoriteProductsKey =
      'restaurant_owner_favorite_products';
  static const String _favoriteBakeriesKey =
      'restaurant_owner_favorite_bakeries';

  @override
  Future<List<FavoriteProduct>> getFavoriteProducts() async {
    // TODO: Remove this when API is ready - Always return mock data for testing
    return _getMockFavoriteProducts();

    // Uncomment below when API is ready:
    // final productsJson = _prefs.getString(_favoriteProductsKey);
    // if (productsJson != null) {
    //   final List<dynamic> productsList = json.decode(productsJson);
    //   return productsList
    //       .map((json) => FavoriteProduct.fromJson(json))
    //       .toList();
    // }
    // return [];
  }

  @override
  Future<List<FavoriteBakery>> getFavoriteBakeries() async {
    // TODO: Remove this when API is ready - Always return mock data for testing
    return _getMockFavoriteBakeries();

    // Uncomment below when API is ready:
    // final bakeriesJson = _prefs.getString(_favoriteBakeriesKey);
    // if (bakeriesJson != null) {
    //   final List<dynamic> bakeriesList = json.decode(bakeriesJson);
    //   return bakeriesList.map((json) => FavoriteBakery.fromJson(json)).toList();
    // }
    // return [];
  }

  @override
  Future<void> addFavoriteProduct(FavoriteProduct product) async {
    final products = await getFavoriteProducts();
    if (!products.any((p) => p.id == product.id)) {
      products.add(product);
      await _saveFavoriteProducts(products);
    }
  }

  @override
  Future<void> addFavoriteBakery(FavoriteBakery bakery) async {
    final bakeries = await getFavoriteBakeries();
    if (!bakeries.any((b) => b.id == bakery.id)) {
      bakeries.add(bakery);
      await _saveFavoriteBakeries(bakeries);
    }
  }

  @override
  Future<void> removeFavoriteProduct(String productId) async {
    final products = await getFavoriteProducts();
    products.removeWhere((p) => p.id == productId);
    await _saveFavoriteProducts(products);
  }

  @override
  Future<void> removeFavoriteBakery(String bakeryId) async {
    final bakeries = await getFavoriteBakeries();
    bakeries.removeWhere((b) => b.id == bakeryId);
    await _saveFavoriteBakeries(bakeries);
  }

  @override
  Future<bool> isProductFavorite(String productId) async {
    // Check against mock data for testing
    final products = await getFavoriteProducts();
    return products.any((p) => p.id == productId);
  }

  @override
  Future<bool> isBakeryFavorite(String bakeryId) async {
    // Check against mock data for testing
    final bakeries = await getFavoriteBakeries();
    return bakeries.any((b) => b.id == bakeryId);
  }

  @override
  Future<void> clearAllFavorites() async {
    await _prefs.remove(_favoriteProductsKey);
    await _prefs.remove(_favoriteBakeriesKey);
  }

  @override
  Future<void> clearFavoriteProducts() async {
    await _prefs.remove(_favoriteProductsKey);
  }

  @override
  Future<void> clearFavoriteBakeries() async {
    await _prefs.remove(_favoriteBakeriesKey);
  }

  Future<void> _saveFavoriteProducts(List<FavoriteProduct> products) async {
    final productsJson = json.encode(
      products.map((p) => p.toJson()).toList(),
    );
    await _prefs.setString(_favoriteProductsKey, productsJson);
  }

  Future<void> _saveFavoriteBakeries(List<FavoriteBakery> bakeries) async {
    final bakeriesJson = json.encode(
      bakeries.map((b) => b.toJson()).toList(),
    );
    await _prefs.setString(_favoriteBakeriesKey, bakeriesJson);
  }

  // Mock data methods - Remove these when API is ready
  List<FavoriteProduct> _getMockFavoriteProducts() {
    final now = DateTime.now();
    return [
      FavoriteProduct(
        id: 'mock_product_1',
        name: 'Fresh White Bread',
        description: 'Soft and fluffy white bread, perfect for sandwiches',
        price: 2.50,
        imageUrl: 'https://via.placeholder.com/300x300?text=White+Bread',
        quantity: '1 loaf',
        bakeryName: 'Al-Bakery',
        bakeryId: 'mock_bakery_1',
        addedAt: now.subtract(const Duration(days: 2)),
      ),
      FavoriteProduct(
        id: 'mock_product_2',
        name: 'Whole Wheat Bread',
        description: 'Healthy whole wheat bread with grains',
        price: 3.00,
        imageUrl: 'https://via.placeholder.com/300x300?text=Wheat+Bread',
        quantity: '1 loaf',
        bakeryName: 'Golden Oven',
        bakeryId: 'mock_bakery_2',
        addedAt: now.subtract(const Duration(days: 5)),
      ),
      FavoriteProduct(
        id: 'mock_product_3',
        name: 'Croissant',
        description: 'Buttery French croissant, flaky and delicious',
        price: 1.75,
        imageUrl: 'https://via.placeholder.com/300x300?text=Croissant',
        quantity: '1 piece',
        bakeryName: 'Paris Bakery',
        bakeryId: 'mock_bakery_3',
        addedAt: now.subtract(const Duration(days: 1)),
      ),
      FavoriteProduct(
        id: 'mock_product_4',
        name: 'Chocolate Chip Cookies',
        description: 'Homemade cookies with premium chocolate chips',
        price: 4.50,
        imageUrl: 'https://via.placeholder.com/300x300?text=Cookies',
        quantity: '12 pieces',
        bakeryName: 'Sweet Dreams Bakery',
        bakeryId: 'mock_bakery_4',
        addedAt: now.subtract(const Duration(days: 3)),
      ),
      FavoriteProduct(
        id: 'mock_product_5',
        name: 'Bagels',
        description: 'Fresh New York style bagels',
        price: 2.25,
        imageUrl: 'https://via.placeholder.com/300x300?text=Bagels',
        quantity: '6 pieces',
        bakeryName: 'Al-Bakery',
        bakeryId: 'mock_bakery_1',
        addedAt: now.subtract(const Duration(days: 4)),
      ),
      FavoriteProduct(
        id: 'mock_product_6',
        name: 'Sourdough Bread',
        description: 'Artisan sourdough with tangy flavor',
        price: 4.00,
        imageUrl: 'https://via.placeholder.com/300x300?text=Sourdough',
        quantity: '1 loaf',
        bakeryName: 'Golden Oven',
        bakeryId: 'mock_bakery_2',
        addedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }

  List<FavoriteBakery> _getMockFavoriteBakeries() {
    final now = DateTime.now();
    return [
      FavoriteBakery(
        id: 'mock_bakery_1',
        name: 'Al-Bakery',
        description:
            'Traditional bakery serving fresh bread and pastries daily',
        rating: 4.5,
        reviewCount: 128,
        address: '123 Main Street, Amman, Jordan',
        imageUrl: 'https://via.placeholder.com/400x300?text=Al-Bakery',
        addedAt: now.subtract(const Duration(days: 10)),
      ),
      FavoriteBakery(
        id: 'mock_bakery_2',
        name: 'Golden Oven',
        description: 'Premium bakery specializing in artisan breads',
        rating: 4.8,
        reviewCount: 256,
        address: '456 King Hussein Street, Amman, Jordan',
        imageUrl: 'https://via.placeholder.com/400x300?text=Golden+Oven',
        addedAt: now.subtract(const Duration(days: 7)),
      ),
      FavoriteBakery(
        id: 'mock_bakery_3',
        name: 'Paris Bakery',
        description: 'French-inspired bakery with authentic pastries',
        rating: 4.7,
        reviewCount: 189,
        address: '789 Rainbow Street, Amman, Jordan',
        imageUrl: 'https://via.placeholder.com/400x300?text=Paris+Bakery',
        addedAt: now.subtract(const Duration(days: 15)),
      ),
      FavoriteBakery(
        id: 'mock_bakery_4',
        name: 'Sweet Dreams Bakery',
        description: 'Your go-to place for cakes, cookies, and sweet treats',
        rating: 4.6,
        reviewCount: 203,
        address: '321 Jabal Amman, Amman, Jordan',
        imageUrl: 'https://via.placeholder.com/400x300?text=Sweet+Dreams',
        addedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
