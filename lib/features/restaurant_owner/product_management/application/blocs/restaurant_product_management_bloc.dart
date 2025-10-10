import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:khubzati/features/restaurant_owner/product_management/data/services/restaurant_product_management_service.dart';

part 'restaurant_product_management_event.dart';
part 'restaurant_product_management_state.dart';

class RestaurantProductManagementBloc extends Bloc<
    RestaurantProductManagementEvent, RestaurantProductManagementState> {
  final RestaurantProductManagementService productManagementService;

  RestaurantProductManagementBloc({
    required this.productManagementService,
  }) : super(RestaurantProductManagementInitial()) {
    on<LoadRestaurantProducts>(_onLoadRestaurantProducts);
    on<LoadRestaurantProductCategories>(_onLoadRestaurantProductCategories);
    on<AddRestaurantProduct>(_onAddRestaurantProduct);
    on<UpdateRestaurantProduct>(_onUpdateRestaurantProduct);
    on<DeleteRestaurantProduct>(_onDeleteRestaurantProduct);
    on<AddRestaurantProductCategory>(_onAddRestaurantProductCategory);
    on<UpdateRestaurantProductCategory>(_onUpdateRestaurantProductCategory);
    on<DeleteRestaurantProductCategory>(_onDeleteRestaurantProductCategory);
    on<UpdateRestaurantProductAvailability>(
        _onUpdateRestaurantProductAvailability);
    on<UploadRestaurantProductImages>(_onUploadRestaurantProductImages);
    on<DeleteRestaurantProductImage>(_onDeleteRestaurantProductImage);
  }

  Future<void> _onLoadRestaurantProducts(LoadRestaurantProducts event,
      Emitter<RestaurantProductManagementState> emit) async {
    // If we're loading the first page or changing filters, emit loading state
    if (event.page == 1 ||
        (state is RestaurantProductsLoaded &&
            ((state as RestaurantProductsLoaded).currentCategoryId !=
                    event.categoryId ||
                (state as RestaurantProductsLoaded).currentSearchQuery !=
                    event.searchQuery))) {
      emit(RestaurantProductsLoading());
    }

    try {
      // Call API to get products
      final response = await productManagementService.getMenuItems(
        categoryId: event.categoryId,
        searchTerm: event.searchQuery,
        page: event.page,
        limit: event.limit,
      );

      final products = response['menu_items'];
      final pagination = response['pagination'];
      final totalCount = pagination['total_count'] ?? 0;
      final currentPage = pagination['current_page'] ?? event.page;
      final limit = pagination['per_page'] ?? event.limit;
      final hasReachedMax = (currentPage * limit) >= totalCount;

      if (state is RestaurantProductsLoaded && event.page > 1) {
        // Append to existing list for pagination
        final currentState = state as RestaurantProductsLoaded;
        emit(currentState.copyWith(
          products: List.of(currentState.products)..addAll(products),
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
          currentCategoryId: event.categoryId,
          currentSearchQuery: event.searchQuery,
        ));
      } else {
        // First load or filter change
        emit(RestaurantProductsLoaded(
          products: products,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
          currentCategoryId: event.categoryId,
          currentSearchQuery: event.searchQuery,
        ));
      }
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to load menu items: ${e.toString()}'));
    }
  }

  Future<void> _onLoadRestaurantProductCategories(
      LoadRestaurantProductCategories event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(RestaurantCategoriesLoading());
    try {
      // Call API to get categories
      final categories = await productManagementService.getCategories();

      emit(RestaurantCategoriesLoaded(categories: categories));
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> _onAddRestaurantProduct(AddRestaurantProduct event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantProductOperationInProgress('add'));
    try {
      // Call API to add product
      final newProduct =
          await productManagementService.createMenuItem(event.product);

      emit(RestaurantProductOperationSuccess(
        operationType: 'add',
        message: 'Menu item added successfully',
        product: newProduct,
      ));

      // Refresh product list if we were in loaded state
      if (state is RestaurantProductsLoaded) {
        final currentState = state as RestaurantProductsLoaded;
        add(LoadRestaurantProducts(
          categoryId: currentState.currentCategoryId,
          searchQuery: currentState.currentSearchQuery,
          page: 1, // Reset to first page
        ));
      }
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to add menu item: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateRestaurantProduct(UpdateRestaurantProduct event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantProductOperationInProgress('update'));
    try {
      // Call API to update product
      final updatedProduct = await productManagementService.updateMenuItem(
          event.productId, event.updatedProduct);

      emit(RestaurantProductOperationSuccess(
        operationType: 'update',
        message: 'Menu item updated successfully',
        product: updatedProduct,
      ));

      // Update product in list if we were in loaded state
      if (state is RestaurantProductsLoaded) {
        final currentState = state as RestaurantProductsLoaded;
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.products);
        final index =
            updatedProducts.indexWhere((p) => p['id'] == event.productId);

        if (index != -1) {
          updatedProducts[index] = updatedProduct;
          emit(currentState.copyWith(products: updatedProducts));
        } else {
          // If product wasn't in the current list, refresh from server
          add(LoadRestaurantProducts(
            categoryId: currentState.currentCategoryId,
            searchQuery: currentState.currentSearchQuery,
            page: 1, // Reset to first page
          ));
        }
      }
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to update menu item: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteRestaurantProduct(DeleteRestaurantProduct event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantProductOperationInProgress('delete'));
    try {
      // Call API to delete product
      await productManagementService.deleteMenuItem(event.productId);

      emit(const RestaurantProductOperationSuccess(
        operationType: 'delete',
        message: 'Menu item deleted successfully',
      ));

      // Remove product from list if we were in loaded state
      if (state is RestaurantProductsLoaded) {
        final currentState = state as RestaurantProductsLoaded;
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.products)
              ..removeWhere((p) => p['id'] == event.productId);

        emit(currentState.copyWith(products: updatedProducts));
      }
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to delete menu item: ${e.toString()}'));
    }
  }

  Future<void> _onAddRestaurantProductCategory(
      AddRestaurantProductCategory event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantCategoryOperationInProgress('add'));
    try {
      // Call API to add category
      final newCategory = await productManagementService.createCategory({
        'name': event.name,
        'description': event.description,
        // 'imageUrl': event.imageUrl, // Handle image upload separately if needed
      });

      emit(RestaurantCategoryOperationSuccess(
        operationType: 'add',
        message: 'Category added successfully',
        category: newCategory,
      ));

      // Refresh categories
      add(const LoadRestaurantProductCategories());
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to add category: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateRestaurantProductCategory(
      UpdateRestaurantProductCategory event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantCategoryOperationInProgress('update'));
    try {
      // Prepare update data
      final updateData = <String, dynamic>{};
      if (event.name != null) updateData['name'] = event.name;
      if (event.description != null) {
        updateData['description'] = event.description;
      }
      // if (event.imageUrl != null) updateData['imageUrl'] = event.imageUrl; // Handle image upload separately

      // Call API to update category
      final updatedCategory = await productManagementService.updateCategory(
          event.categoryId, updateData);

      emit(RestaurantCategoryOperationSuccess(
        operationType: 'update',
        message: 'Category updated successfully',
        category: updatedCategory,
      ));

      // Refresh categories
      add(const LoadRestaurantProductCategories());
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to update category: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteRestaurantProductCategory(
      DeleteRestaurantProductCategory event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantCategoryOperationInProgress('delete'));
    try {
      // Call API to delete category
      await productManagementService.deleteCategory(event.categoryId);

      emit(const RestaurantCategoryOperationSuccess(
        operationType: 'delete',
        message: 'Category deleted successfully',
      ));

      // Refresh categories
      add(const LoadRestaurantProductCategories());

      // If we were viewing products from this category, reset to all products
      if (state is RestaurantProductsLoaded) {
        final currentState = state as RestaurantProductsLoaded;
        if (currentState.currentCategoryId == event.categoryId) {
          add(const LoadRestaurantProducts(page: 1));
        }
      }
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to delete category: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateRestaurantProductAvailability(
      UpdateRestaurantProductAvailability event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantProductOperationInProgress('update_availability'));
    try {
      // Call API to update availability
      final updatedProduct = await productManagementService
          .updateMenuItemAvailability(event.productId, event.isAvailable);

      final message = event.isAvailable
          ? 'Menu item is now available for ordering'
          : 'Menu item is now unavailable for ordering';

      emit(RestaurantProductOperationSuccess(
        operationType: 'update_availability',
        message: message,
        product: updatedProduct,
      ));

      // Update product in list if we were in loaded state
      if (state is RestaurantProductsLoaded) {
        final currentState = state as RestaurantProductsLoaded;
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
      emit(RestaurantProductManagementError(
          'Failed to update menu item availability: ${e.toString()}'));
    }
  }

  Future<void> _onUploadRestaurantProductImages(
      UploadRestaurantProductImages event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantProductOperationInProgress('upload_images'));
    try {
      // Call API to upload images
      final updatedProduct = await productManagementService
          .uploadMenuItemImages(event.productId, event.imageFiles);

      emit(RestaurantProductOperationSuccess(
        operationType: 'upload_images',
        message: 'Menu item images uploaded successfully',
        product: updatedProduct,
      ));

      // Update product in list if we were in loaded state
      if (state is RestaurantProductsLoaded) {
        final currentState = state as RestaurantProductsLoaded;
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
      emit(RestaurantProductManagementError(
          'Failed to upload menu item images: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteRestaurantProductImage(
      DeleteRestaurantProductImage event,
      Emitter<RestaurantProductManagementState> emit) async {
    emit(const RestaurantProductOperationInProgress('delete_image'));
    try {
      // Call API to delete image
      await productManagementService.deleteMenuItemImage(
          event.productId, event.imageId);

      emit(const RestaurantProductOperationSuccess(
        operationType: 'delete_image',
        message: 'Menu item image deleted successfully',
      ));

      // Refresh product list or details to reflect the change
      if (state is RestaurantProductsLoaded) {
        final currentState = state as RestaurantProductsLoaded;
        // Find the product and update its image list (or just reload)
        add(LoadRestaurantProducts(
          categoryId: currentState.currentCategoryId,
          searchQuery: currentState.currentSearchQuery,
          page: 1, // Reset to first page
        ));
      }
    } catch (e) {
      emit(RestaurantProductManagementError(
          'Failed to delete menu item image: ${e.toString()}'));
    }
  }
}
