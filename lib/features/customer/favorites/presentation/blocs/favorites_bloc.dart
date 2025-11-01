import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/models/favorite_item.dart';
import 'favorites_event.dart' as events;
import 'favorites_state.dart' as states;

@injectable
class FavoritesBloc extends Bloc<events.FavoritesEvent, states.FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc(this._favoritesRepository)
      : super(const states.FavoritesInitial()) {
    on<events.FavoritesLoaded>(_onFavoritesLoaded);
    on<events.FavoritesFilterChanged>(_onFavoritesFilterChanged);
    on<events.FavoriteItemRemoved>(_onFavoriteItemRemoved);
    on<events.FavoriteItemAdded>(_onFavoriteItemAdded);
    on<events.AllFavoritesCleared>(_onAllFavoritesCleared);
    on<events.FavoriteVendorsCleared>(_onFavoriteVendorsCleared);
    on<events.FavoriteProductsCleared>(_onFavoriteProductsCleared);
    on<events.FavoriteItemTapped>(_onFavoriteItemTapped);
  }

  Future<void> _onFavoritesLoaded(
    events.FavoritesLoaded event,
    Emitter<states.FavoritesState> emit,
  ) async {
    emit(const states.FavoritesLoading());

    try {
      final allFavorites = await _favoritesRepository.getFavorites();
      final favoriteVendors = await _favoritesRepository.getFavoriteVendors();
      final favoriteProducts = await _favoritesRepository.getFavoriteProducts();

      emit(states.FavoritesLoaded(
        allFavorites: allFavorites,
        favoriteVendors: favoriteVendors,
        favoriteProducts: favoriteProducts,
        currentFilter: 'all',
        filteredFavorites: allFavorites,
      ));
    } catch (e) {
      emit(states.FavoritesError(e.toString()));
    }
  }

  Future<void> _onFavoritesFilterChanged(
    events.FavoritesFilterChanged event,
    Emitter<states.FavoritesState> emit,
  ) async {
    if (state is states.FavoritesLoaded) {
      final currentState = state as states.FavoritesLoaded;
      List<FavoriteItem> filteredFavorites;

      switch (event.filter) {
        case 'vendors':
          filteredFavorites = currentState.favoriteVendors;
          break;
        case 'products':
          filteredFavorites = currentState.favoriteProducts;
          break;
        default:
          filteredFavorites = currentState.allFavorites;
      }

      emit(currentState.copyWith(
        currentFilter: event.filter,
        filteredFavorites: filteredFavorites,
      ));
    }
  }

  Future<void> _onFavoriteItemRemoved(
    events.FavoriteItemRemoved event,
    Emitter<states.FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.removeFromFavorites(event.itemId);

      if (state is states.FavoritesLoaded) {
        final currentState = state as states.FavoritesLoaded;
        final updatedAllFavorites = currentState.allFavorites
            .where((item) => item.id != event.itemId)
            .toList();
        final updatedFavoriteVendors = currentState.favoriteVendors
            .where((item) => item.id != event.itemId)
            .toList();
        final updatedFavoriteProducts = currentState.favoriteProducts
            .where((item) => item.id != event.itemId)
            .toList();

        List<FavoriteItem> updatedFilteredFavorites;
        switch (currentState.currentFilter) {
          case 'vendors':
            updatedFilteredFavorites = updatedFavoriteVendors;
            break;
          case 'products':
            updatedFilteredFavorites = updatedFavoriteProducts;
            break;
          default:
            updatedFilteredFavorites = updatedAllFavorites;
        }

        emit(currentState.copyWith(
          allFavorites: updatedAllFavorites,
          favoriteVendors: updatedFavoriteVendors,
          favoriteProducts: updatedFavoriteProducts,
          filteredFavorites: updatedFilteredFavorites,
        ));
      }
    } catch (e) {
      emit(states.FavoritesError(e.toString()));
    }
  }

  Future<void> _onFavoriteItemAdded(
    events.FavoriteItemAdded event,
    Emitter<states.FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.addToFavorites(event.item);

      if (state is states.FavoritesLoaded) {
        final currentState = state as states.FavoritesLoaded;
        final updatedAllFavorites = [...currentState.allFavorites, event.item];

        List<FavoriteItem> updatedFavoriteVendors =
            currentState.favoriteVendors;
        List<FavoriteItem> updatedFavoriteProducts =
            currentState.favoriteProducts;

        if (event.item.type == 'vendor') {
          updatedFavoriteVendors = [
            ...currentState.favoriteVendors,
            event.item
          ];
        } else if (event.item.type == 'product') {
          updatedFavoriteProducts = [
            ...currentState.favoriteProducts,
            event.item
          ];
        }

        List<FavoriteItem> updatedFilteredFavorites;
        switch (currentState.currentFilter) {
          case 'vendors':
            updatedFilteredFavorites = updatedFavoriteVendors;
            break;
          case 'products':
            updatedFilteredFavorites = updatedFavoriteProducts;
            break;
          default:
            updatedFilteredFavorites = updatedAllFavorites;
        }

        emit(currentState.copyWith(
          allFavorites: updatedAllFavorites,
          favoriteVendors: updatedFavoriteVendors,
          favoriteProducts: updatedFavoriteProducts,
          filteredFavorites: updatedFilteredFavorites,
        ));
      }
    } catch (e) {
      emit(states.FavoritesError(e.toString()));
    }
  }

  Future<void> _onAllFavoritesCleared(
    events.AllFavoritesCleared event,
    Emitter<states.FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.clearAllFavorites();
      emit(const states.FavoritesEmpty('all'));
    } catch (e) {
      emit(states.FavoritesError(e.toString()));
    }
  }

  Future<void> _onFavoriteVendorsCleared(
    events.FavoriteVendorsCleared event,
    Emitter<states.FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.clearFavoriteVendors();

      if (state is states.FavoritesLoaded) {
        final currentState = state as states.FavoritesLoaded;
        final updatedAllFavorites = currentState.allFavorites
            .where((item) => item.type != 'vendor')
            .toList();
        final updatedFilteredFavorites = currentState.filteredFavorites
            .where((item) => item.type != 'vendor')
            .toList();

        emit(currentState.copyWith(
          allFavorites: updatedAllFavorites,
          favoriteVendors: const [],
          filteredFavorites: updatedFilteredFavorites,
        ));
      }
    } catch (e) {
      emit(states.FavoritesError(e.toString()));
    }
  }

  Future<void> _onFavoriteProductsCleared(
    events.FavoriteProductsCleared event,
    Emitter<states.FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.clearFavoriteProducts();

      if (state is states.FavoritesLoaded) {
        final currentState = state as states.FavoritesLoaded;
        final updatedAllFavorites = currentState.allFavorites
            .where((item) => item.type != 'product')
            .toList();
        final updatedFilteredFavorites = currentState.filteredFavorites
            .where((item) => item.type != 'product')
            .toList();

        emit(currentState.copyWith(
          allFavorites: updatedAllFavorites,
          favoriteProducts: const [],
          filteredFavorites: updatedFilteredFavorites,
        ));
      }
    } catch (e) {
      emit(states.FavoritesError(e.toString()));
    }
  }

  Future<void> _onFavoriteItemTapped(
    events.FavoriteItemTapped event,
    Emitter<states.FavoritesState> emit,
  ) async {
    // Handle navigation to item details
    // This would typically be handled by the UI layer
  }
}
