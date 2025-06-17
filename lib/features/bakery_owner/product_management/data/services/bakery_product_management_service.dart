import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';
import 'package:dio/dio.dart';

class BakeryProductManagementService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches all products for the bakery owner
  /// 
  /// [page] is the page number for pagination (starts from 1)
  /// [limit] is the number of products per page
  /// [categoryId] optional filter for products in a specific category
  /// [searchTerm] optional search term to filter products
  /// Returns paginated list of products with their details
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? searchTerm,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }
      
      if (searchTerm != null) {
        queryParams['search'] = searchTerm;
      }
      
      final response = await _apiClient.get(
        ApiConstants.bakeryProducts,
        queryParameters: queryParams,
        requiresAuth: true,
      );
      
      return {
        'products': List<Map<String, dynamic>>.from(response['data'] ?? []),
        'pagination': Map<String, dynamic>.from(response['meta']['pagination'] ?? {}),
      };
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Fetches detailed information for a specific product
  /// 
  /// [productId] is the ID of the product to fetch details for
  /// Returns comprehensive product details
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.bakeryProductDetail}$productId',
        requiresAuth: true,
      );
      
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Creates a new product
  /// 
  /// [productData] contains all product details (name, description, price, category, etc.)
  /// Returns the newly created product data
  /// Throws [ApiError] if the creation fails
  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.bakeryProducts,
        data: productData,
        requiresAuth: true,
      );
      
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Updates an existing product
  /// 
  /// [productId] is the ID of the product to update
  /// [productData] contains the updated product fields
  /// Returns the updated product data
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateProduct(String productId, Map<String, dynamic> productData) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.bakeryProductDetail}$productId',
        data: productData,
        requiresAuth: true,
      );
      
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Deletes a product
  /// 
  /// [productId] is the ID of the product to delete
  /// Returns success status
  /// Throws [ApiError] if the deletion fails
  Future<bool> deleteProduct(String productId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.bakeryProductDetail}$productId',
        requiresAuth: true,
      );
      
      return true;
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Updates product availability status
  /// 
  /// [productId] is the ID of the product to update
  /// [isAvailable] indicates whether the product should be available or not
  /// Returns the updated product data
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateProductAvailability(String productId, bool isAvailable) async {
    try {
      final response = await _apiClient.patch(
        '${ApiConstants.bakeryProductDetail}$productId/availability',
        data: {'is_available': isAvailable},
        requiresAuth: true,
      );
      
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Uploads product images
  /// 
  /// [productId] is the ID of the product to upload images for
  /// [imageFiles] is a list of image files to upload
  /// Returns the updated product data with new image URLs
  /// Throws [ApiError] if the upload fails
  Future<Map<String, dynamic>> uploadProductImages(String productId, List<dynamic> imageFiles) async {
    try {
      final formData = FormData();
      
      for (var i = 0; i < imageFiles.length; i++) {
        formData.files.add(
          MapEntry(
            'images[$i]',
            await MultipartFile.fromFile(
              imageFiles[i].path,
              filename: imageFiles[i].path.split('/').last,
            ),
          ),
        );
      }
      
      final response = await _apiClient.post(
        '${ApiConstants.bakeryProductDetail}$productId/images',
        data: formData,
        requiresAuth: true,
      );
      
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Deletes a product image
  /// 
  /// [productId] is the ID of the product
  /// [imageId] is the ID of the image to delete
  /// Returns success status
  /// Throws [ApiError] if the deletion fails
  Future<bool> deleteProductImage(String productId, String imageId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.bakeryProductDetail}$productId/images/$imageId',
        requiresAuth: true,
      );
      
      return true;
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Fetches all product categories
  /// 
  /// Returns list of product categories
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.bakeryCategories,
        requiresAuth: true,
      );
      
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Creates a new product category
  /// 
  /// [categoryData] contains category details (name, description, etc.)
  /// Returns the newly created category data
  /// Throws [ApiError] if the creation fails
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.bakeryCategories,
        data: categoryData,
        requiresAuth: true,
      );
      
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Updates an existing product category
  /// 
  /// [categoryId] is the ID of the category to update
  /// [categoryData] contains the updated category fields
  /// Returns the updated category data
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateCategory(String categoryId, Map<String, dynamic> categoryData) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.bakeryCategoryDetail}$categoryId',
        data: categoryData,
        requiresAuth: true,
      );
      
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  /// Deletes a product category
  /// 
  /// [categoryId] is the ID of the category to delete
  /// Returns success status
  /// Throws [ApiError] if the deletion fails
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.bakeryCategoryDetail}$categoryId',
        requiresAuth: true,
      );
      
      return true;
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }
}
