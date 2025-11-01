import 'package:injectable/injectable.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_state.dart';

@injectable
class RestaurantOwnerHomeService {
  Future<List<RestaurantItem>> getRestaurants() async {
    // Mock data - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(10, (index) {
      return RestaurantItem(
        id: 'restaurant_$index',
        name: 'مخابز قاسيون ${index + 1}',
        description:
            'لوريم إيبسوم هو ببساطة نص شكلي يستخدم في صناعة الطباعة والتنضيد...',
        rating: 4.0 + (index * 0.1),
        reviewCount: 100 + (index * 50),
        deliveryTime: '${20 + (index * 5)} دقيقة',
        imageUrl: 'assets/images/restaurant_$index.jpg',
        isFavorite: index % 3 == 0,
      );
    });
  }

  Future<List<RestaurantItem>> searchRestaurants(String query) async {
    // Mock search - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    final allRestaurants = await getRestaurants();
    if (query.isEmpty) return allRestaurants;

    return allRestaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<List<RestaurantItem>> filterRestaurants(String filter) async {
    // Mock filter - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));

    final allRestaurants = await getRestaurants();
    if (filter.isEmpty) return allRestaurants;

    // Mock filter logic
    switch (filter) {
      case 'rating':
        return allRestaurants.where((r) => r.rating >= 4.5).toList();
      case 'fast_delivery':
        return allRestaurants
            .where((r) => r.deliveryTime.contains('20'))
            .toList();
      case 'favorites':
        return allRestaurants.where((r) => r.isFavorite).toList();
      default:
        return allRestaurants;
    }
  }

  Future<void> toggleFavorite(String restaurantId) async {
    // Mock favorite toggle - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 200));
    // In real implementation, this would call the API to toggle favorite status
  }
}
