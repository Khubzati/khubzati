import 'package:khubzati/core/api/api_client.dart';
import 'package:khubzati/core/api/api_constants.dart';
import 'package:khubzati/core/api/api_error.dart';
import 'package:dio/dio.dart';

class RestaurantProductManagementService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches all menu items for the restaurant owner
  /// 
  /// [page] is the page number for pagination (starts from 1)
  /// [limit] is the number of items per page
  /// [categoryId] optional filter for items in a specific category
  /// [searchTerm] optional search term to filter items
  /// Returns paginated list of menu items with their details
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getMenuItems({
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
        ApiConstants.restaurantProducts,
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

  /// Fetches detailed information for a specific menu item
  /// 
  /// [itemId] is the ID of the menu item to fetch details for
  /// Returns comprehensive menu item details
  /// Throws [ApiError] if the request fails
  Future<Map<String, dynamic>> getMenuItemDetails(String itemId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.restaurantProductDetail}$itemId',
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

  /// Creates a new menu item
  /// 
  /// [itemData] contains all menu item details (name, description, price, category, etc.)
  /// Returns the newly created menu item data
  /// Throws [ApiError] if the creation fails
  Future<Map<String, dynamic>> createMenuItem(Map<String, dynamic> itemData) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.restaurantProducts,
        data: itemData,
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

  /// Updates an existing menu item
  /// 
  /// [itemId] is the ID of the menu item to update
  /// [itemData] contains the updated menu item fields
  /// Returns the updated menu item data
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateMenuItem(String itemId, Map<String, dynamic> itemData) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.restaurantProductDetail}$itemId',
        data: itemData,
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

  /// Deletes a menu item
  /// 
  /// [itemId] is the ID of the menu item to delete
  /// Returns success status
  /// Throws [ApiError] if the deletion fails
  Future<bool> deleteMenuItem(String itemId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.restaurantProductDetail}$itemId',
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

  /// Updates menu item availability status
  /// 
  /// [itemId] is the ID of the menu item to update
  /// [isAvailable] indicates whether the menu item should be available or not
  /// Returns the updated menu item data
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateMenuItemAvailability(String itemId, bool isAvailable) async {
    try {
      final response = await _apiClient.patch(
        '${ApiConstants.restaurantProductDetail}$itemId/availability',
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

  /// Uploads menu item images
  /// 
  /// [itemId] is the ID of the menu item to upload images for
  /// [imageFiles] is a list of image files to upload
  /// Returns the updated menu item data with new image URLs
  /// Throws [ApiError] if the upload fails
  Future<Map<String, dynamic>> uploadMenuItemImages(String itemId, List<dynamic> imageFiles) async {
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
        '${ApiConstants.restaurantProductDetail}$itemId/images',
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

  /// Deletes a menu item image
  /// 
  /// [itemId] is the ID of the menu item
  /// [imageId] is the ID of the image to delete
  /// Returns success status
  /// Throws [ApiError] if the deletion fails
  Future<bool> deleteMenuItemImage(String itemId, String imageId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.restaurantProductDetail}$itemId/images/$imageId',
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

  /// Fetches all menu categories
  /// 
  /// Returns list of menu categories
  /// Throws [ApiError] if the request fails
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.restaurantCategories,
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

  /// Creates a new menu category
  /// 
  /// [categoryData] contains category details (name, description, etc.)
  /// Returns the newly created category data
  /// Throws [ApiError] if the creation fails
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.restaurantCategories,
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

  /// Updates an existing menu category
  /// 
  /// [categoryId] is the ID of the category to update
  /// [categoryData] contains the updated category fields
  /// Returns the updated category data
  /// Throws [ApiError] if the update fails
  Future<Map<String, dynamic>> updateCategory(String categoryId, Map<String, dynamic> categoryData) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.restaurantCategoryDetail}$categoryId',
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

  /// Deletes a menu category
  /// 
  /// [categoryId] is the ID of the category to delete
  /// Returns success status
  /// Throws [ApiError] if the deletion fails
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.restaurantCategoryDetail}$categoryId',
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
