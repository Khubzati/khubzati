import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khubzati/features/bakery_owner/product_management/data/services/bakery_product_management_service.dart';

part 'bakery_product_management_event.dart';
part 'bakery_product_management_state.dart';

class BakeryProductManagementBloc
    extends Bloc<BakeryProductManagementEvent, BakeryProductManagementState> {
  final BakeryProductManagementService productManagementService;

  BakeryProductManagementBloc({
    required this.productManagementService,
  }) : super(BakeryProductManagementInitial()) {
    on<LoadBakeryProducts>(_onLoadBakeryProducts);
    on<LoadBakeryProductCategories>(_onLoadBakeryProductCategories);
    on<AddBakeryProduct>(_onAddBakeryProduct);
    on<UpdateBakeryProduct>(_onUpdateBakeryProduct);
    on<DeleteBakeryProduct>(_onDeleteBakeryProduct);
    on<AddBakeryProductCategory>(_onAddBakeryProductCategory);
    on<UpdateBakeryProductCategory>(_onUpdateBakeryProductCategory);
    on<DeleteBakeryProductCategory>(_onDeleteBakeryProductCategory);
    on<UpdateBakeryProductAvailability>(_onUpdateBakeryProductAvailability);
    on<UploadBakeryProductImages>(_onUploadBakeryProductImages);
    on<DeleteBakeryProductImage>(_onDeleteBakeryProductImage);
  }

  Future<void> _onLoadBakeryProducts(LoadBakeryProducts event,
      Emitter<BakeryProductManagementState> emit) async {
    // If we're loading the first page or changing filters, emit loading state
    if (event.page == 1 ||
        (state is BakeryProductsLoaded &&
            ((state as BakeryProductsLoaded).currentCategoryId !=
                    event.categoryId ||
                (state as BakeryProductsLoaded).currentSearchQuery !=
                    event.searchQuery))) {
      emit(BakeryProductsLoading());
    }

    try {
      // Call API to get products
      final response = await productManagementService.getProducts(
        categoryId: event.categoryId,
        searchTerm: event.searchQuery,
        page: event.page,
        limit: event.limit,
      );

      final products = response['products'];
      final pagination = response['pagination'];
      final totalCount = pagination['total_count'] ?? 0;
      final currentPage = pagination['current_page'] ?? event.page;
      final limit = pagination['per_page'] ?? event.limit;
      final hasReachedMax = (currentPage * limit) >= totalCount;

      if (state is BakeryProductsLoaded && event.page > 1) {
        // Append to existing list for pagination
        final currentState = state as BakeryProductsLoaded;
        emit(currentState.copyWith(
          products: List.of(currentState.products)..addAll(products),
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
          currentCategoryId: event.categoryId,
          currentSearchQuery: event.searchQuery,
        ));
      } else {
        // First load or filter change
        emit(BakeryProductsLoaded(
          products: products,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
          currentCategoryId: event.categoryId,
          currentSearchQuery: event.searchQuery,
        ));
      }
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to load products: ${e.toString()}'));
    }
  }

  Future<void> _onLoadBakeryProductCategories(LoadBakeryProductCategories event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(BakeryCategoriesLoading());
    try {
      // Call API to get categories
      final categories = await productManagementService.getCategories();

      emit(BakeryCategoriesLoaded(categories: categories));
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> _onAddBakeryProduct(AddBakeryProduct event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryProductOperationInProgress('add'));
    try {
      // Call API to add product
      final newProduct =
          await productManagementService.createProduct(event.product);

      emit(BakeryProductOperationSuccess(
        operationType: 'add',
        message: 'Product added successfully',
        product: newProduct,
      ));

      // Refresh product list if we were in loaded state
      if (state is BakeryProductsLoaded) {
        final currentState = state as BakeryProductsLoaded;
        add(LoadBakeryProducts(
          categoryId: currentState.currentCategoryId,
          searchQuery: currentState.currentSearchQuery,
          page: 1, // Reset to first page
        ));
      }
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to add product: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBakeryProduct(UpdateBakeryProduct event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryProductOperationInProgress('update'));
    try {
      // Call API to update product
      final updatedProduct = await productManagementService.updateProduct(
          event.productId, event.updatedProduct);

      emit(BakeryProductOperationSuccess(
        operationType: 'update',
        message: 'Product updated successfully',
        product: updatedProduct,
      ));

      // Update product in list if we were in loaded state
      if (state is BakeryProductsLoaded) {
        final currentState = state as BakeryProductsLoaded;
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.products);
        final index =
            updatedProducts.indexWhere((p) => p['id'] == event.productId);

        if (index != -1) {
          updatedProducts[index] = updatedProduct;
          emit(currentState.copyWith(products: updatedProducts));
        } else {
          // If product wasn't in the current list, refresh from server
          add(LoadBakeryProducts(
            categoryId: currentState.currentCategoryId,
            searchQuery: currentState.currentSearchQuery,
            page: 1, // Reset to first page
          ));
        }
      }
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to update product: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteBakeryProduct(DeleteBakeryProduct event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryProductOperationInProgress('delete'));
    try {
      // Call API to delete product
      await productManagementService.deleteProduct(event.productId);

      emit(BakeryProductOperationSuccess(
        operationType: 'delete',
        message: 'Product deleted successfully',
      ));

      // Remove product from list if we were in loaded state
      if (state is BakeryProductsLoaded) {
        final currentState = state as BakeryProductsLoaded;
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.products)
              ..removeWhere((p) => p['id'] == event.productId);

        emit(currentState.copyWith(products: updatedProducts));
      }
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to delete product: ${e.toString()}'));
    }
  }

  Future<void> _onAddBakeryProductCategory(AddBakeryProductCategory event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryCategoryOperationInProgress('add'));
    try {
      // Call API to add category
      final newCategory = await productManagementService.createCategory({
        'name': event.name,
        'description': event.description,
        // 'imageUrl': event.imageUrl, // Handle image upload separately if needed
      });

      emit(BakeryCategoryOperationSuccess(
        operationType: 'add',
        message: 'Category added successfully',
        category: newCategory,
      ));

      // Refresh categories
      add(LoadBakeryProductCategories());
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to add category: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBakeryProductCategory(UpdateBakeryProductCategory event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryCategoryOperationInProgress('update'));
    try {
      // Prepare update data
      final updateData = <String, dynamic>{};
      if (event.name != null) updateData['name'] = event.name;
      if (event.description != null)
        updateData['description'] = event.description;
      // if (event.imageUrl != null) updateData['imageUrl'] = event.imageUrl; // Handle image upload separately

      // Call API to update category
      final updatedCategory = await productManagementService.updateCategory(
          event.categoryId, updateData);

      emit(BakeryCategoryOperationSuccess(
        operationType: 'update',
        message: 'Category updated successfully',
        category: updatedCategory,
      ));

      // Refresh categories
      add(LoadBakeryProductCategories());
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to update category: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteBakeryProductCategory(DeleteBakeryProductCategory event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryCategoryOperationInProgress('delete'));
    try {
      // Call API to delete category
      await productManagementService.deleteCategory(event.categoryId);

      emit(BakeryCategoryOperationSuccess(
        operationType: 'delete',
        message: 'Category deleted successfully',
      ));

      // Refresh categories
      add(LoadBakeryProductCategories());

      // If we were viewing products from this category, reset to all products
      if (state is BakeryProductsLoaded) {
        final currentState = state as BakeryProductsLoaded;
        if (currentState.currentCategoryId == event.categoryId) {
          add(const LoadBakeryProducts(page: 1));
        }
      }
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to delete category: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBakeryProductAvailability(
      UpdateBakeryProductAvailability event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryProductOperationInProgress('update_availability'));
    try {
      // Call API to update availability
      final updatedProduct = await productManagementService
          .updateProductAvailability(event.productId, event.isAvailable);

      final message = event.isAvailable
          ? 'Product is now available for purchase'
          : 'Product is now unavailable for purchase';

      emit(BakeryProductOperationSuccess(
        operationType: 'update_availability',
        message: message,
        product: updatedProduct,
      ));

      // Update product in list if we were in loaded state
      if (state is BakeryProductsLoaded) {
        final currentState = state as BakeryProductsLoaded;
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.products);
        final index =
            updatedProducts.indexWhere((p) => p['id'] == event.productId);

        if (index != -1) {
          updatedProducts[index] = updatedProduct;
          emit(currentState.copyWith(products: updatedProducts));
        }
      }
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to update product availability: ${e.toString()}'));
    }
  }

  Future<void> _onUploadBakeryProductImages(UploadBakeryProductImages event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryProductOperationInProgress('upload_images'));
    try {
      // Call API to upload images
      final updatedProduct = await productManagementService.uploadProductImages(
          event.productId, event.imageFiles);

      emit(BakeryProductOperationSuccess(
        operationType: 'upload_images',
        message: 'Product images uploaded successfully',
        product: updatedProduct,
      ));

      // Update product in list if we were in loaded state
      if (state is BakeryProductsLoaded) {
        final currentState = state as BakeryProductsLoaded;
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.products);
        final index =
            updatedProducts.indexWhere((p) => p['id'] == event.productId);

        if (index != -1) {
          updatedProducts[index] = updatedProduct;
          emit(currentState.copyWith(products: updatedProducts));
        }
      }
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to upload product images: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteBakeryProductImage(DeleteBakeryProductImage event,
      Emitter<BakeryProductManagementState> emit) async {
    emit(const BakeryProductOperationInProgress('delete_image'));
    try {
      // Call API to delete image
      await productManagementService.deleteProductImage(
          event.productId, event.imageId);

      emit(BakeryProductOperationSuccess(
        operationType: 'delete_image',
        message: 'Product image deleted successfully',
      ));

      // Refresh product list or details to reflect the change
      if (state is BakeryProductsLoaded) {
        final currentState = state as BakeryProductsLoaded;
        // Find the product and update its image list (or just reload)
        add(LoadBakeryProducts(
          categoryId: currentState.currentCategoryId,
          searchQuery: currentState.currentSearchQuery,
          page: 1, // Reset to first page
        ));
      }
    } catch (e) {
      emit(BakeryProductManagementError(
          'Failed to delete product image: ${e.toString()}'));
    }
  }
}
