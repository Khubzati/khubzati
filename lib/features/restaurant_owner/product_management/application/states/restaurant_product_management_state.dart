part of 'restaurant_product_management_bloc.dart';

abstract class RestaurantProductManagementState extends Equatable {
  const RestaurantProductManagementState();

  @override
  List<Object?> get props => [];
}

class RestaurantProductManagementInitial extends RestaurantProductManagementState {}

class RestaurantProductsLoading extends RestaurantProductManagementState {}

class RestaurantProductsLoaded extends RestaurantProductManagementState {
  final List<Map<String, dynamic>> products;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentCategoryId;
  final String? currentSearchQuery;

  const RestaurantProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.currentCategoryId,
    this.currentSearchQuery,
  });

  RestaurantProductsLoaded copyWith({
    List<Map<String, dynamic>>? products,
    bool? hasReachedMax,
    int? currentPage,
    String? currentCategoryId,
    String? currentSearchQuery,
  }) {
    return RestaurantProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
    );
  }

  @override
  List<Object?> get props => [products, hasReachedMax, currentPage, currentCategoryId, currentSearchQuery];
}

class RestaurantCategoriesLoading extends RestaurantProductManagementState {}

class RestaurantCategoriesLoaded extends RestaurantProductManagementState {
  final List<Map<String, dynamic>> categories;

  const RestaurantCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class RestaurantProductOperationInProgress extends RestaurantProductManagementState {
  final String operationType; // 'add', 'update', 'delete', 'update_availability'

  const RestaurantProductOperationInProgress(this.operationType);

  @override
  List<Object?> get props => [operationType];
}

class RestaurantProductOperationSuccess extends RestaurantProductManagementState {
  final String operationType; // 'add', 'update', 'delete', 'update_availability'
  final String message;
  final Map<String, dynamic>? product; // The affected product, if applicable

  const RestaurantProductOperationSuccess({
    required this.operationType,
    required this.message,
    this.product,
  });

  @override
  List<Object?> get props => [operationType, message, product];
}

class RestaurantCategoryOperationInProgress extends RestaurantProductManagementState {
  final String operationType; // 'add', 'update', 'delete'

  const RestaurantCategoryOperationInProgress(this.operationType);

  @override
  List<Object?> get props => [operationType];
}

class RestaurantCategoryOperationSuccess extends RestaurantProductManagementState {
  final String operationType; // 'add', 'update', 'delete'
  final String message;
  final Map<String, dynamic>? category; // The affected category, if applicable

  const RestaurantCategoryOperationSuccess({
    required this.operationType,
    required this.message,
    this.category,
  });

  @override
  List<Object?> get props => [operationType, message, category];
}

class RestaurantProductManagementError extends RestaurantProductManagementState {
  final String message;

  const RestaurantProductManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
