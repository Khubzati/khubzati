part of 'bakery_product_management_bloc.dart';

abstract class BakeryProductManagementEvent extends Equatable {
  const BakeryProductManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadBakeryProducts extends BakeryProductManagementEvent {
  final String? categoryId;
  final String? searchQuery;
  final int page;
  final int limit;

  const LoadBakeryProducts({
    this.categoryId,
    this.searchQuery,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [categoryId, searchQuery, page, limit];
}

class LoadBakeryProductCategories extends BakeryProductManagementEvent {}

class AddBakeryProduct extends BakeryProductManagementEvent {
  final Map<String, dynamic> product;

  const AddBakeryProduct({required this.product});

  @override
  List<Object?> get props => [product];
}

class UpdateBakeryProduct extends BakeryProductManagementEvent {
  final String productId;
  final Map<String, dynamic> updatedProduct;

  const UpdateBakeryProduct({
    required this.productId,
    required this.updatedProduct,
  });

  @override
  List<Object?> get props => [productId, updatedProduct];
}

class DeleteBakeryProduct extends BakeryProductManagementEvent {
  final String productId;

  const DeleteBakeryProduct({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class AddBakeryProductCategory extends BakeryProductManagementEvent {
  final String name;
  final String? description;
  final String? imageUrl;

  const AddBakeryProductCategory({
    required this.name,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, description, imageUrl];
}

class UpdateBakeryProductCategory extends BakeryProductManagementEvent {
  final String categoryId;
  final String? name;
  final String? description;
  final String? imageUrl;

  const UpdateBakeryProductCategory({
    required this.categoryId,
    this.name,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [categoryId, name, description, imageUrl];
}

class DeleteBakeryProductCategory extends BakeryProductManagementEvent {
  final String categoryId;

  const DeleteBakeryProductCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class UpdateBakeryProductAvailability extends BakeryProductManagementEvent {
  final String productId;
  final bool isAvailable;

  const UpdateBakeryProductAvailability({
    required this.productId,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [productId, isAvailable];
}

class UploadBakeryProductImages extends BakeryProductManagementEvent {
  final String productId;
  final List<dynamic> imageFiles; // List of File objects or image data

  const UploadBakeryProductImages({
    required this.productId,
    required this.imageFiles,
  });

  @override
  List<Object?> get props => [productId, imageFiles];
}

class DeleteBakeryProductImage extends BakeryProductManagementEvent {
  final String productId;
  final String imageId;

  const DeleteBakeryProductImage({
    required this.productId,
    required this.imageId,
  });

  @override
  List<Object?> get props => [productId, imageId];
}
