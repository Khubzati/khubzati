part of 'bakery_product_management_bloc.dart';

abstract class BakeryProductManagementState extends Equatable {
  const BakeryProductManagementState();

  @override
  List<Object?> get props => [];
}

class BakeryProductManagementInitial extends BakeryProductManagementState {}

class BakeryProductsLoading extends BakeryProductManagementState {}

class BakeryProductsLoaded extends BakeryProductManagementState {
  final List<Map<String, dynamic>> products;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentCategoryId;
  final String? currentSearchQuery;

  const BakeryProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.currentCategoryId,
    this.currentSearchQuery,
  });

  BakeryProductsLoaded copyWith({
    List<Map<String, dynamic>>? products,
    bool? hasReachedMax,
    int? currentPage,
    String? currentCategoryId,
    String? currentSearchQuery,
  }) {
    return BakeryProductsLoaded(
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

class BakeryCategoriesLoading extends BakeryProductManagementState {}

class BakeryCategoriesLoaded extends BakeryProductManagementState {
  final List<Map<String, dynamic>> categories;

  const BakeryCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class BakeryProductOperationInProgress extends BakeryProductManagementState {
  final String operationType; // 'add', 'update', 'delete', 'update_availability'

  const BakeryProductOperationInProgress(this.operationType);

  @override
  List<Object?> get props => [operationType];
}

class BakeryProductOperationSuccess extends BakeryProductManagementState {
  final String operationType; // 'add', 'update', 'delete', 'update_availability'
  final String message;
  final Map<String, dynamic>? product; // The affected product, if applicable

  const BakeryProductOperationSuccess({
    required this.operationType,
    required this.message,
    this.product,
  });

  @override
  List<Object?> get props => [operationType, message, product];
}

class BakeryCategoryOperationInProgress extends BakeryProductManagementState {
  final String operationType; // 'add', 'update', 'delete'

  const BakeryCategoryOperationInProgress(this.operationType);

  @override
  List<Object?> get props => [operationType];
}

class BakeryCategoryOperationSuccess extends BakeryProductManagementState {
  final String operationType; // 'add', 'update', 'delete'
  final String message;
  final Map<String, dynamic>? category; // The affected category, if applicable

  const BakeryCategoryOperationSuccess({
    required this.operationType,
    required this.message,
    this.category,
  });

  @override
  List<Object?> get props => [operationType, message, category];
}

class BakeryProductManagementError extends BakeryProductManagementState {
  final String message;

  const BakeryProductManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
