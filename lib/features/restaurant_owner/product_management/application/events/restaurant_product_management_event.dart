part of 'restaurant_product_management_bloc.dart';

abstract class RestaurantProductManagementEvent extends Equatable {
  const RestaurantProductManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantProducts extends RestaurantProductManagementEvent {
  final String? categoryId;
  final String? searchQuery;
  final int page;
  final int limit;

  const LoadRestaurantProducts({
    this.categoryId,
    this.searchQuery,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [categoryId, searchQuery, page, limit];
}

class LoadRestaurantProductCategories extends RestaurantProductManagementEvent {}

class AddRestaurantProduct extends RestaurantProductManagementEvent {
  final Map<String, dynamic> product;

  const AddRestaurantProduct({required this.product});

  @override
  List<Object?> get props => [product];
}

class UpdateRestaurantProduct extends RestaurantProductManagementEvent {
  final String productId;
  final Map<String, dynamic> updatedProduct;

  const UpdateRestaurantProduct({
    required this.productId,
    required this.updatedProduct,
  });

  @override
  List<Object?> get props => [productId, updatedProduct];
}

class DeleteRestaurantProduct extends RestaurantProductManagementEvent {
  final String productId;

  const DeleteRestaurantProduct({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class AddRestaurantProductCategory extends RestaurantProductManagementEvent {
  final String name;
  final String? description;
  final String? imageUrl;

  const AddRestaurantProductCategory({
    required this.name,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, description, imageUrl];
}

class UpdateRestaurantProductCategory extends RestaurantProductManagementEvent {
  final String categoryId;
  final String? name;
  final String? description;
  final String? imageUrl;

  const UpdateRestaurantProductCategory({
    required this.categoryId,
    this.name,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [categoryId, name, description, imageUrl];
}

class DeleteRestaurantProductCategory extends RestaurantProductManagementEvent {
  final String categoryId;

  const DeleteRestaurantProductCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class UpdateRestaurantProductAvailability extends RestaurantProductManagementEvent {
  final String productId;
  final bool isAvailable;

  const UpdateRestaurantProductAvailability({
    required this.productId,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [productId, isAvailable];
}
