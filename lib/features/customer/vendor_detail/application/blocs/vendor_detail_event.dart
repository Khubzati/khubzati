part of 'vendor_detail_bloc.dart';

abstract class VendorDetailEvent extends Equatable {
  const VendorDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchVendorDetails extends VendorDetailEvent {
  final String vendorId;
  const FetchVendorDetails({required this.vendorId});

  @override
  List<Object> get props => [vendorId];
}

// Add other events like FetchVendorProducts, FetchVendorReviews, SelectProductCategory if needed

