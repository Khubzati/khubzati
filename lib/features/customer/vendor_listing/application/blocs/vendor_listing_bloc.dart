import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/features/customer/vendor_listing/data/services/vendor_listing_service.dart';

part 'vendor_listing_event.dart';
part 'vendor_listing_state.dart';

const _vendorLimit = 10; // Number of vendors to fetch per page

class VendorListingBloc extends Bloc<VendorListingEvent, VendorListingState> {
  final VendorListingService vendorService;

  VendorListingBloc({required this.vendorService})
      : super(VendorListingInitial()) {
    on<FetchVendorsByCategory>(_onFetchVendorsByCategory);
    on<SearchVendorsInListing>(_onSearchVendorsInListing);
    on<ApplyVendorFilters>(_onApplyVendorFilters);
    on<ClearVendorFilters>(_onClearVendorFilters);
    on<LoadMoreVendors>(_onLoadMoreVendors);
  }

  Future<void> _onFetchVendorsByCategory(
      FetchVendorsByCategory event, Emitter<VendorListingState> emit) async {
    emit(VendorListingLoading());
    try {
      final response = await vendorService.getVendors(
        type: event.categoryId,
        page: 1,
        limit: _vendorLimit,
      );

      final vendors = List<Map<String, dynamic>>.from(response['data'] ?? []);
      final hasReachedMax = vendors.length < _vendorLimit;

      emit(VendorListingLoaded(vendors: vendors, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(VendorListingError('Failed to fetch vendors: ${e.toString()}'));
    }
  }

  Future<void> _onSearchVendorsInListing(
      SearchVendorsInListing event, Emitter<VendorListingState> emit) async {
    emit(VendorListingLoading());
    try {
      final response = await vendorService.getVendors(
        type: event.categoryId,
        searchQuery: event.query,
        page: 1,
        limit: _vendorLimit,
      );

      final vendors = List<Map<String, dynamic>>.from(response['data'] ?? []);
      final hasReachedMax = vendors.length < _vendorLimit;

      emit(VendorListingLoaded(vendors: vendors, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(VendorListingError('Failed to search vendors: ${e.toString()}'));
    }
  }

  Future<void> _onApplyVendorFilters(
      ApplyVendorFilters event, Emitter<VendorListingState> emit) async {
    emit(VendorListingLoading());
    try {
      final response = await vendorService.getVendors(
        type: event.filters['type'],
        searchQuery: event.filters['searchQuery'],
        sortBy: event.filters['sortBy'],
        sortOrder: event.filters['sortOrder'],
        minRating: event.filters['minRating'],
        maxDeliveryTime: event.filters['maxDeliveryTime'],
        priceRange: event.filters['priceRange'],
        latitude: event.filters['latitude'],
        longitude: event.filters['longitude'],
        page: 1,
        limit: _vendorLimit,
      );

      final vendors = List<Map<String, dynamic>>.from(response['data'] ?? []);
      final hasReachedMax = vendors.length < _vendorLimit;

      emit(VendorListingFiltered(
          vendors: vendors, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(VendorListingError('Failed to apply filters: ${e.toString()}'));
    }
  }

  Future<void> _onClearVendorFilters(
      ClearVendorFilters event, Emitter<VendorListingState> emit) async {
    // This event might re-trigger FetchVendorsByCategory or a similar event without filters
    // For now, just emitting initial to signify filters cleared, actual data fetch would follow.
    // Or, it could fetch the original unfiltered list for the current category.
    add(const FetchVendorsByCategory(
        categoryId:
            'current_category_id_placeholder')); // Placeholder, needs actual category context
  }

  Future<void> _onLoadMoreVendors(
      LoadMoreVendors event, Emitter<VendorListingState> emit) async {
    if (state is VendorListingLoaded &&
        !(state as VendorListingLoaded).hasReachedMax) {
      final currentState = state as VendorListingLoaded;
      try {
        final nextPage = (currentState.vendors.length ~/ _vendorLimit) + 1;
        final response = await vendorService.getVendors(
          type: event.categoryId,
          page: nextPage,
          limit: _vendorLimit,
        );

        final newVendors =
            List<Map<String, dynamic>>.from(response['data'] ?? []);

        if (newVendors.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(currentState.copyWith(
            vendors: List.of(currentState.vendors)..addAll(newVendors),
            hasReachedMax: newVendors.length < _vendorLimit,
          ));
        }
      } catch (e) {
        // Could emit a specific LoadMoreError state or just update current state with an error message
        // For simplicity, not changing state on load more error, or one could add an error field to VendorListingLoaded
        print('Failed to load more vendors: ${e.toString()}');
      }
    }
  }
}
