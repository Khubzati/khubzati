import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// Import your models and services here
// e.g., import 'package:khubzati/core/models/vendor_model.dart';
// import 'package:khubzati/core/services/vendor_service.dart';

part 'vendor_listing_event.dart';
part 'vendor_listing_state.dart';

const _vendorLimit = 10; // Number of vendors to fetch per page

class VendorListingBloc extends Bloc<VendorListingEvent, VendorListingState> {
  // final VendorService vendorService; // Assuming a service to fetch vendor data

  VendorListingBloc(/*{required this.vendorService}*/) : super(VendorListingInitial()) {
    on<FetchVendorsByCategory>(_onFetchVendorsByCategory);
    on<SearchVendorsInListing>(_onSearchVendorsInListing);
    on<ApplyVendorFilters>(_onApplyVendorFilters);
    on<ClearVendorFilters>(_onClearVendorFilters);
    on<LoadMoreVendors>(_onLoadMoreVendors);
  }

  Future<void> _onFetchVendorsByCategory(FetchVendorsByCategory event, Emitter<VendorListingState> emit) async {
    emit(VendorListingLoading());
    try {
      // TODO: Replace with actual API call from vendorService
      // final vendors = await vendorService.getVendorsByCategory(event.categoryId, limit: _vendorLimit, page: 1);
      
      // Placeholder data
      await Future.delayed(const Duration(milliseconds: 700));
      final vendors = List.generate(_vendorLimit, (i) => 'Vendor for ${event.categoryId} ${i + 1}');
      
      emit(VendorListingLoaded(vendors: vendors, hasReachedMax: vendors.length < _vendorLimit));
    } catch (e) {
      emit(VendorListingError('Failed to fetch vendors: ${e.toString()}'));
    }
  }

  Future<void> _onSearchVendorsInListing(SearchVendorsInListing event, Emitter<VendorListingState> emit) async {
    emit(VendorListingLoading()); // Or a specific SearchLoading state
    try {
      // TODO: Replace with actual API call from vendorService for search
      // final vendors = await vendorService.searchVendors(query: event.query, categoryId: event.categoryId, limit: _vendorLimit, page: 1);
      
      // Placeholder data
      await Future.delayed(const Duration(milliseconds: 500));
      final vendors = List.generate(5, (i) => 'Searched Vendor ${i + 1} for "${event.query}" in category ${event.categoryId ?? "All"}');
      
      emit(VendorListingLoaded(vendors: vendors, hasReachedMax: true)); // Assuming search doesn't paginate or resets pagination
    } catch (e) {
      emit(VendorListingError('Failed to search vendors: ${e.toString()}'));
    }
  }

  Future<void> _onApplyVendorFilters(ApplyVendorFilters event, Emitter<VendorListingState> emit) async {
    emit(VendorListingLoading());
    try {
      // TODO: Apply filters and fetch data from vendorService
      // final vendors = await vendorService.getVendorsWithFilters(event.filters, limit: _vendorLimit, page: 1);
      
      // Placeholder data
      await Future.delayed(const Duration(milliseconds: 600));
      final vendors = List.generate(3, (i) => 'Filtered Vendor ${i + 1} with filters: ${event.filters.toString()}');
      
      emit(VendorListingFiltered(vendors: vendors, hasReachedMax: true)); // Assuming filter resets pagination
    } catch (e) {
      emit(VendorListingError('Failed to apply filters: ${e.toString()}'));
    }
  }

  Future<void> _onClearVendorFilters(ClearVendorFilters event, Emitter<VendorListingState> emit) async {
    // This event might re-trigger FetchVendorsByCategory or a similar event without filters
    // For now, just emitting initial to signify filters cleared, actual data fetch would follow.
    // Or, it could fetch the original unfiltered list for the current category.
    add(const FetchVendorsByCategory(categoryId: 'current_category_id_placeholder')); // Placeholder, needs actual category context
  }

  Future<void> _onLoadMoreVendors(LoadMoreVendors event, Emitter<VendorListingState> emit) async {
    if (state is VendorListingLoaded && !(state as VendorListingLoaded).hasReachedMax) {
      final currentState = state as VendorListingLoaded;
      try {
        // TODO: Replace with actual API call for pagination
        // final nextPage = (currentState.vendors.length ~/ _vendorLimit) + 1;
        // final newVendors = await vendorService.getVendorsByCategory(event.categoryId, limit: _vendorLimit, page: nextPage);

        // Placeholder data
        await Future.delayed(const Duration(milliseconds: 700));
        final newVendors = List.generate(_vendorLimit - 5, (i) => 'More Vendor for ${event.categoryId} ${currentState.vendors.length + i + 1}');

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

