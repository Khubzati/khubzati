import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import your models and services here
// e.g., import 'package:khubzati/core/models/banner_model.dart';
// import 'package:khubzati/core/services/home_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // final HomeService homeService; // Assuming a service to fetch home data

  HomeBloc(/*{required this.homeService}*/) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
    on<SearchVendors>(_onSearchVendors);
  }

  Future<void> _onFetchHomeData(
      FetchHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // TODO: Replace with actual API call from homeService
      // final banners = await homeService.getBanners();
      // final categories = await homeService.getCategories();
      // final popularVendors = await homeService.getPopularVendors();
      // final nearbyVendors = await homeService.getNearbyVendors();

      // Placeholder data
      await Future.delayed(const Duration(milliseconds: 800));
      final banners = [
        {
          'id': '1',
          'title': 'Special Offer',
          'subtitle': '50% off on all items',
          'image': 'https://example.com/banner1.jpg'
        },
        {
          'id': '2',
          'title': 'New Arrivals',
          'subtitle': 'Fresh baked goods',
          'image': 'https://example.com/banner2.jpg'
        },
        {
          'id': '3',
          'title': 'Weekend Special',
          'subtitle': 'Free delivery',
          'image': 'https://example.com/banner3.jpg'
        },
      ];
      final categories = [
        {'id': '1', 'name': 'Bakery', 'type': 'bakery'},
        {'id': '2', 'name': 'Restaurant', 'type': 'restaurant'},
        {'id': '3', 'name': 'Sweets', 'type': 'bakery'},
        {'id': '4', 'name': 'Coffee', 'type': 'restaurant'},
      ];
      final popularVendors = [
        {
          'id': '1',
          'name': 'Popular Bakery A',
          'cuisine_type': 'Bakery',
          'rating': 4.5,
          'delivery_time': 30,
          'image': 'https://example.com/vendor1.jpg'
        },
        {
          'id': '2',
          'name': 'Popular Restaurant B',
          'cuisine_type': 'Italian',
          'rating': 4.8,
          'delivery_time': 25,
          'image': 'https://example.com/vendor2.jpg'
        },
      ];
      final nearbyVendors = [
        {
          'id': '3',
          'name': 'Nearby Bakery X',
          'cuisine_type': 'Bakery',
          'rating': 4.2,
          'delivery_time': 20,
          'image': 'https://example.com/vendor3.jpg'
        },
        {
          'id': '4',
          'name': 'Nearby Restaurant Y',
          'cuisine_type': 'Arabic',
          'rating': 4.6,
          'delivery_time': 35,
          'image': 'https://example.com/vendor4.jpg'
        },
        {
          'id': '5',
          'name': 'Nearby Cafe Z',
          'cuisine_type': 'Coffee',
          'rating': 4.3,
          'delivery_time': 15,
          'image': 'https://example.com/vendor5.jpg'
        },
      ];

      emit(HomeLoaded(
        banners: banners,
        categories: categories,
        popularVendors: popularVendors,
        nearbyVendors: nearbyVendors,
      ));
    } catch (e) {
      emit(HomeError('Failed to fetch home data: ${e.toString()}'));
    }
  }

  Future<void> _onSearchVendors(
      SearchVendors event, Emitter<HomeState> emit) async {
    emit(HomeSearchLoading());
    try {
      // TODO: Replace with actual API call from homeService for search
      // final results = await homeService.searchVendors(event.query);

      // Placeholder data
      await Future.delayed(const Duration(milliseconds: 500));
      final results = [
        'Searched Vendor 1 for "${event.query}"',
        'Searched Vendor 2 for "${event.query}"'
      ];

      emit(HomeSearchLoaded(results));
    } catch (e) {
      emit(HomeError('Failed to search vendors: ${e.toString()}'));
      // Optionally, revert to a previous state or a specific search error state
      // For simplicity, emitting general HomeError here
    }
  }
}
