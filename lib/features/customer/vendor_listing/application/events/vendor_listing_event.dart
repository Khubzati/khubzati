part of 'vendor_listing_bloc.dart';

abstract class VendorListingEvent extends Equatable {
  const VendorListingEvent();

  @override
  List<Object?> get props => [];
}

class FetchVendorsByCategory extends VendorListingEvent {
  final String categoryId;
  // Add other parameters like filters, sort options, pagination
  const FetchVendorsByCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class SearchVendorsInListing extends VendorListingEvent {
  final String query;
  final String? categoryId; // Optional: to search within a category
  const SearchVendorsInListing({required this.query, this.categoryId});

  @override
  List<Object?> get props => [query, categoryId];
}

class ApplyVendorFilters extends VendorListingEvent {
  // final VendorFilterModel filters; // Assuming a filter model
  final Map<String, dynamic> filters; // Placeholder for filter model
  const ApplyVendorFilters({required this.filters});

  @override
  List<Object?> get props => [filters];
}

class ClearVendorFilters extends VendorListingEvent {}

class LoadMoreVendors extends VendorListingEvent {
  final String categoryId;
  const LoadMoreVendors({required this.categoryId});

   @override
  List<Object?> get props => [categoryId];
}

