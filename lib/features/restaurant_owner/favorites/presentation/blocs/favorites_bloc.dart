import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/models/favorite_bakery.dart';
import 'favorites_event.dart' as events;
import 'favorites_state.dart' as states;

@injectable
class RestaurantOwnerFavoritesBloc
    extends Bloc<events.RestaurantOwnerFavoritesEvent,
        states.RestaurantOwnerFavoritesState> {
  final RestaurantOwnerFavoritesRepository _repository;

  RestaurantOwnerFavoritesBloc(this._repository)
      : super(const states.RestaurantOwnerFavoritesInitial()) {
    on<events.LoadFavorites>(_onLoadFavorites);
    on<events.SwitchTab>(_onSwitchTab);
    on<events.SearchBakeries>(_onSearchBakeries);
    on<events.RemoveFavoriteProduct>(_onRemoveFavoriteProduct);
    on<events.RemoveFavoriteBakery>(_onRemoveFavoriteBakery);
    on<events.ClearAllFavorites>(_onClearAllFavorites);
    on<events.ClearFavoriteProducts>(_onClearFavoriteProducts);
    on<events.ClearFavoriteBakeries>(_onClearFavoriteBakeries);
  }

  Future<void> _onLoadFavorites(
    events.LoadFavorites event,
    Emitter<states.RestaurantOwnerFavoritesState> emit,
  ) async {
    emit(const states.RestaurantOwnerFavoritesLoading());

    try {
      final products = await _repository.getFavoriteProducts();
      final bakeries = await _repository.getFavoriteBakeries();

      if (products.isEmpty && bakeries.isEmpty) {
        emit(const states.RestaurantOwnerFavoritesEmpty('items'));
      } else {
        emit(states.RestaurantOwnerFavoritesLoaded(
          favoriteProducts: products,
          favoriteBakeries: bakeries,
        ));
      }
    } catch (e) {
      emit(states.RestaurantOwnerFavoritesError(e.toString()));
    }
  }

  Future<void> _onSwitchTab(
    events.SwitchTab event,
    Emitter<states.RestaurantOwnerFavoritesState> emit,
  ) async {
    if (state is states.RestaurantOwnerFavoritesLoaded) {
      final currentState = state as states.RestaurantOwnerFavoritesLoaded;
      emit(currentState.copyWith(currentTab: event.tab));
    }
  }

  Future<void> _onSearchBakeries(
    events.SearchBakeries event,
    Emitter<states.RestaurantOwnerFavoritesState> emit,
  ) async {
    if (state is states.RestaurantOwnerFavoritesLoaded) {
      final currentState = state as states.RestaurantOwnerFavoritesLoaded;
      List<FavoriteBakery> filteredBakeries;

      if (event.query.isEmpty) {
        filteredBakeries = currentState.favoriteBakeries;
      } else {
        filteredBakeries = currentState.favoriteBakeries.where((bakery) {
          return bakery.name.toLowerCase().contains(event.query.toLowerCase()) ||
              bakery.description
                  .toLowerCase()
                  .contains(event.query.toLowerCase()) ||
              bakery.address.toLowerCase().contains(event.query.toLowerCase());
        }).toList();
      }

      emit(currentState.copyWith(
        searchQuery: event.query,
        filteredBakeries: filteredBakeries,
      ));
    }
  }

  Future<void> _onRemoveFavoriteProduct(
    events.RemoveFavoriteProduct event,
    Emitter<states.RestaurantOwnerFavoritesState> emit,
  ) async {
    try {
      await _repository.removeFavoriteProduct(event.productId);

      if (state is states.RestaurantOwnerFavoritesLoaded) {
        final currentState = state as states.RestaurantOwnerFavoritesLoaded;
        final updatedProducts = currentState.favoriteProducts
            .where((p) => p.id != event.productId)
            .toList();

        if (updatedProducts.isEmpty && currentState.favoriteBakeries.isEmpty) {
          emit(const states.RestaurantOwnerFavoritesEmpty('items'));
        } else {
          emit(currentState.copyWith(favoriteProducts: updatedProducts));
        }
      }
    } catch (e) {
      emit(states.RestaurantOwnerFavoritesError(e.toString()));
    }
  }

  Future<void> _onRemoveFavoriteBakery(
    events.RemoveFavoriteBakery event,
    Emitter<states.RestaurantOwnerFavoritesState> emit,
  ) async {
    try {
      await _repository.removeFavoriteBakery(event.bakeryId);

      if (state is states.RestaurantOwnerFavoritesLoaded) {
        final currentState = state as states.RestaurantOwnerFavoritesLoaded;
        final updatedBakeries = currentState.favoriteBakeries
            .where((b) => b.id != event.bakeryId)
            .toList();

        final filteredBakeries = currentState.searchQuery.isEmpty
            ? updatedBakeries
            : updatedBakeries.where((bakery) {
                return bakery.name
                        .toLowerCase()
                        .contains(currentState.searchQuery.toLowerCase()) ||
                    bakery.description
                        .toLowerCase()
                        .contains(currentState.searchQuery.toLowerCase()) ||
                    bakery.address
                        .toLowerCase()
                        .contains(currentState.searchQuery.toLowerCase());
              }).toList();

        if (currentState.favoriteProducts.isEmpty && updatedBakeries.isEmpty) {
          emit(const states.RestaurantOwnerFavoritesEmpty('bakeries'));
        } else {
          emit(currentState.copyWith(
            favoriteBakeries: updatedBakeries,
            filteredBakeries: filteredBakeries,
          ));
        }
      }
    } catch (e) {
      emit(states.RestaurantOwnerFavoritesError(e.toString()));
    }
  }

  Future<void> _onClearAllFavorites(
    events.ClearAllFavorites event,
    Emitter<states.RestaurantOwnerFavoritesState> emit,
  ) async {
    try {
      await _repository.clearAllFavorites();
      emit(const states.RestaurantOwnerFavoritesEmpty('items'));
    } catch (e) {
      emit(states.RestaurantOwnerFavoritesError(e.toString()));
    }
  }

  Future<void> _onClearFavoriteProducts(
    events.ClearFavoriteProducts event,
    Emitter<states.RestaurantOwnerFavoritesState> emit,
  ) async {
    try {
      await _repository.clearFavoriteProducts();

      if (state is states.RestaurantOwnerFavoritesLoaded) {
        final currentState = state as states.RestaurantOwnerFavoritesLoaded;
        if (currentState.favoriteBakeries.isEmpty) {
          emit(const states.RestaurantOwnerFavoritesEmpty('items'));
        } else {
          emit(currentState.copyWith(favoriteProducts: []));
        }
      }
    } catch (e) {
      emit(states.RestaurantOwnerFavoritesError(e.toString()));
    }
  }

  Future<void> _onClearFavoriteBakeries(
    events.ClearFavoriteBakeries event,
    Emitter<states.RestaurantOwnerFavoritesState> emit,
  ) async {
    try {
      await _repository.clearFavoriteBakeries();

      if (state is states.RestaurantOwnerFavoritesLoaded) {
        final currentState = state as states.RestaurantOwnerFavoritesLoaded;
        if (currentState.favoriteProducts.isEmpty) {
          emit(const states.RestaurantOwnerFavoritesEmpty('bakeries'));
        } else {
          emit(currentState.copyWith(
            favoriteBakeries: [],
            filteredBakeries: [],
          ));
        }
      }
    } catch (e) {
      emit(states.RestaurantOwnerFavoritesError(e.toString()));
    }
  }
}

