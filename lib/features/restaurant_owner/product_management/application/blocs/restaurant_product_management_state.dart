part of 'restaurant_product_management_bloc.dart';

abstract class RestaurantProductManagementState extends Equatable {
  const RestaurantProductManagementState();

  @override
  List<Object?> get props => [];
}

class RestaurantProductManagementInitial extends RestaurantProductManagementState {}

class RestaurantProductsLoading extends RestaurantProductManagementState {}

class RestaurantCategoriesLoading extends RestaurantProductManagementState {}

class RestaurantProductOperationInProgress extends RestaurantProductManagementState {
  final String operationType;

  const RestaurantProductOperationInProgress(this.operationType);

  @override
  List<Object?> get props => [operationType];
}

class RestaurantCategoryOperationInProgress extends RestaurantProductManagementState {
  final String operationType;

  const RestaurantCategoryOperationInProgress(this.operationType);

  @override
  List<Object?> get props => [operationType];
}

class RestaurantProductOperationSuccess extends RestaurantProductManagementState {
  final String operationType;
  final String message;
  final Map<String, dynamic>? product;

  const RestaurantProductOperationSuccess({
    required this.operationType,
    required this.message,
    this.product,
  });

  @override
  List<Object?> get props => [operationType, message, product];
}

class RestaurantCategoryOperationSuccess extends RestaurantProductManagementState {
  final String operationType;
  final String message;
  final Map<String, dynamic>? category;

  const RestaurantCategoryOperationSuccess({
    required this.operationType,
    required this.message,
    this.category,
  });

  @override
  List<Object?> get props => [operationType, message, category];
}

class RestaurantProductsLoaded extends RestaurantProductManagementState {
  final List<Map<String, dynamic>> products;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentCategoryId;
  final String? currentSearchQuery;

  const RestaurantProductsLoaded({
    required this.products,
    required this.hasReachedMax,
    required this.currentPage,
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
  List<Object?> get props => [
        products,
        hasReachedMax,
        currentPage,
        currentCategoryId,
        currentSearchQuery,
      ];
}

class RestaurantCategoriesLoaded extends RestaurantProductManagementState {
  final List<Map<String, dynamic>> categories;

  const RestaurantCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class RestaurantProductManagementError extends RestaurantProductManagementState {
  final String message;

  const RestaurantProductManagementError(this.message);

  @override
  List<Object?> get props => [message];
}