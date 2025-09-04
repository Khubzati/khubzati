part of 'vendor_detail_bloc.dart';

abstract class VendorDetailState extends Equatable {
  const VendorDetailState();

  @override
  List<Object> get props => [];
}

class VendorDetailInitial extends VendorDetailState {}

class VendorDetailLoading extends VendorDetailState {}

class VendorDetailLoaded extends VendorDetailState {
  // final VendorModel vendorDetails; // Assuming VendorModel for vendor info
  // final List<ProductCategoryModel> productCategories; // Assuming ProductCategoryModel
  // final List<ProductModel> products; // Assuming ProductModel
  // final List<ReviewModel> reviews; // Assuming ReviewModel

  // Using placeholders for now
  final String vendorName;
  final String vendorDescription;
  final List<String> productCategories;
  final Map<String, List<String>> productsByCategory; // CategoryId -> List of Product Names
  final List<String> reviews;

  const VendorDetailLoaded({
    required this.vendorName,
    required this.vendorDescription,
    required this.productCategories,
    required this.productsByCategory,
    required this.reviews,
  });

  @override
  List<Object> get props => [vendorName, vendorDescription, productCategories, productsByCategory, reviews];
}

class VendorDetailError extends VendorDetailState {
  final String message;

  const VendorDetailError(this.message);

  @override
  List<Object> get props => [message];
}

