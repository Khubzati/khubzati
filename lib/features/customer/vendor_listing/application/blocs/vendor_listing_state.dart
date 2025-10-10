part of 'vendor_listing_bloc.dart';

abstract class VendorListingState extends Equatable {
  const VendorListingState();

  @override
  List<Object> get props => [];
}

class VendorListingInitial extends VendorListingState {}

class VendorListingLoading extends VendorListingState {}

class VendorListingLoaded extends VendorListingState {
  // final List<VendorModel> vendors;
  // final bool hasReachedMax;
  final List<Map<String, dynamic>>
      vendors; // Changed from List<String> to List<Map<String, dynamic>>
  final bool hasReachedMax; // Placeholder for pagination

  const VendorListingLoaded(
      {required this.vendors, this.hasReachedMax = false});

  VendorListingLoaded copyWith({
    List<Map<String, dynamic>>? vendors,
    bool? hasReachedMax,
  }) {
    return VendorListingLoaded(
      vendors: vendors ?? this.vendors,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [vendors, hasReachedMax];
}

class VendorListingError extends VendorListingState {
  final String message;

  const VendorListingError(this.message);

  @override
  List<Object> get props => [message];
}

// Specific state for when filters are applied, might not be needed if handled within VendorListingLoaded
class VendorListingFiltered extends VendorListingLoaded {
  const VendorListingFiltered({required super.vendors, super.hasReachedMax});
}
