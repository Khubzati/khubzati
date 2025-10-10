import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// Import your models and services here
// e.g., import 'package:khubzati/core/models/vendor_model.dart';
// import 'package:khubzati/core/services/vendor_service.dart';

part 'vendor_detail_event.dart';
part 'vendor_detail_state.dart';

class VendorDetailBloc extends Bloc<VendorDetailEvent, VendorDetailState> {
  // final VendorService vendorService; // Assuming a service to fetch vendor details

  VendorDetailBloc(/*{required this.vendorService}*/)
      : super(VendorDetailInitial()) {
    on<FetchVendorDetails>(_onFetchVendorDetails);
  }

  Future<void> _onFetchVendorDetails(
      FetchVendorDetails event, Emitter<VendorDetailState> emit) async {
    emit(VendorDetailLoading());
    try {
      // TODO: Replace with actual API call from vendorService to fetch all details
      // final vendorData = await vendorService.getVendorFullDetails(event.vendorId);
      // final vendorDetails = vendorData.details;
      // final productCategories = vendorData.productCategories;
      // final products = vendorData.products; // This might be a map or need further processing
      // final reviews = vendorData.reviews;

      // Placeholder data
      await Future.delayed(const Duration(milliseconds: 750));
      final vendorName = "Awesome Bakery ${event.vendorId}";
      const vendorDescription =
          "The best bakery in town, serving fresh goods daily since 1990. We use only the finest ingredients.";
      final productCategories = ["Breads", "Cakes", "Pastries"];
      final productsByCategory = {
        "Breads": ["Sourdough Loaf", "Baguette", "Whole Wheat Bread"],
        "Cakes": ["Chocolate Fudge Cake", "Red Velvet Cake", "Cheesecake"],
        "Pastries": ["Croissant", "Pain au Chocolat", "Danish Pastry"],
      };
      final reviews = [
        "Great products!",
        "Loved the cake!",
        "Fresh and tasty."
      ];

      emit(VendorDetailLoaded(
        vendorName: vendorName,
        vendorDescription: vendorDescription,
        productCategories: productCategories,
        productsByCategory: productsByCategory,
        reviews: reviews,
      ));
    } catch (e) {
      emit(
          VendorDetailError('Failed to fetch vendor details: ${e.toString()}'));
    }
  }
}
