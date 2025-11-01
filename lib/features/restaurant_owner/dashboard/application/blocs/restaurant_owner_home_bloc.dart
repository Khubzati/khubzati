import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_event.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/application/blocs/restaurant_owner_home_state.dart';
import 'package:khubzati/features/restaurant_owner/dashboard/data/services/restaurant_owner_home_service.dart';

class RestaurantOwnerHomeBloc
    extends Bloc<RestaurantOwnerHomeEvent, RestaurantOwnerHomeState> {
  final RestaurantOwnerHomeService _service;

  RestaurantOwnerHomeBloc({required RestaurantOwnerHomeService service})
      : _service = service,
        super(const RestaurantOwnerHomeInitial()) {
    on<LoadRestaurantOwnerHome>(_onLoadRestaurantOwnerHome);
    on<SearchRestaurants>(_onSearchRestaurants);
    on<FilterRestaurants>(_onFilterRestaurants);
    on<ToggleFavorite>(_onToggleFavorite);
    on<RefreshRestaurants>(_onRefreshRestaurants);
  }

  Future<void> _onLoadRestaurantOwnerHome(
    LoadRestaurantOwnerHome event,
    Emitter<RestaurantOwnerHomeState> emit,
  ) async {
    emit(const RestaurantOwnerHomeLoading());
    try {
      final restaurants = await _service.getRestaurants();
      emit(RestaurantOwnerHomeLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantOwnerHomeError(
          'Failed to load restaurants: ${e.toString()}'));
    }
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurants event,
    Emitter<RestaurantOwnerHomeState> emit,
  ) async {
    if (state is RestaurantOwnerHomeLoaded) {
      final currentState = state as RestaurantOwnerHomeLoaded;
      try {
        final filteredRestaurants =
            await _service.searchRestaurants(event.query);
        emit(currentState.copyWith(
          restaurants: filteredRestaurants,
          searchQuery: event.query,
        ));
      } catch (e) {
        emit(RestaurantOwnerHomeError('Search failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterRestaurants(
    FilterRestaurants event,
    Emitter<RestaurantOwnerHomeState> emit,
  ) async {
    if (state is RestaurantOwnerHomeLoaded) {
      final currentState = state as RestaurantOwnerHomeLoaded;
      try {
        final filteredRestaurants =
            await _service.filterRestaurants(event.filter);
        emit(currentState.copyWith(
          restaurants: filteredRestaurants,
          selectedFilter: event.filter,
        ));
      } catch (e) {
        emit(RestaurantOwnerHomeError('Filter failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<RestaurantOwnerHomeState> emit,
  ) async {
    if (state is RestaurantOwnerHomeLoaded) {
      final currentState = state as RestaurantOwnerHomeLoaded;
      try {
        await _service.toggleFavorite(event.restaurantId);
        final updatedFavorites = Set<String>.from(currentState.favoriteIds);
        if (updatedFavorites.contains(event.restaurantId)) {
          updatedFavorites.remove(event.restaurantId);
        } else {
          updatedFavorites.add(event.restaurantId);
        }

        final updatedRestaurants = currentState.restaurants.map((restaurant) {
          if (restaurant.id == event.restaurantId) {
            return restaurant.copyWith(
              isFavorite: !restaurant.isFavorite,
            );
          }
          return restaurant;
        }).toList();

        emit(currentState.copyWith(
          restaurants: updatedRestaurants,
          favoriteIds: updatedFavorites,
        ));
      } catch (e) {
        emit(RestaurantOwnerHomeError(
            'Failed to toggle favorite: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurants event,
    Emitter<RestaurantOwnerHomeState> emit,
  ) async {
    add(const LoadRestaurantOwnerHome());
  }
}
