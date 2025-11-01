import 'package:equatable/equatable.dart';

abstract class RestaurantOwnerHomeEvent extends Equatable {
  const RestaurantOwnerHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantOwnerHome extends RestaurantOwnerHomeEvent {
  const LoadRestaurantOwnerHome();
}

class SearchRestaurants extends RestaurantOwnerHomeEvent {
  final String query;

  const SearchRestaurants(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterRestaurants extends RestaurantOwnerHomeEvent {
  final String filter;

  const FilterRestaurants(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ToggleFavorite extends RestaurantOwnerHomeEvent {
  final String restaurantId;

  const ToggleFavorite(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}

class RefreshRestaurants extends RestaurantOwnerHomeEvent {
  const RefreshRestaurants();
}
