part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  // final List<BannerModel> banners; // Assuming BannerModel exists
  // final List<CategoryModel> categories; // Assuming CategoryModel exists
  // final List<VendorModel> popularVendors; // Assuming VendorModel exists
  // final List<VendorModel> nearbyVendors; // Assuming VendorModel exists

  // Using placeholders for now
  final List<String> banners;
  final List<String> categories;
  final List<String> popularVendors;
  final List<String> nearbyVendors;

  const HomeLoaded({
    required this.banners,
    required this.categories,
    required this.popularVendors,
    required this.nearbyVendors,
  });

  @override
  List<Object> get props => [banners, categories, popularVendors, nearbyVendors];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

// Could add more specific states, e.g., for search results
class HomeSearchLoading extends HomeState {}

class HomeSearchLoaded extends HomeState {
  // final List<VendorModel> searchResults;
  final List<String> searchResults;
  const HomeSearchLoaded(this.searchResults);

   @override
  List<Object> get props => [searchResults];
}

