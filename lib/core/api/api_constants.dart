class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.khubzati.com/v1'; // Replace with actual API base URL
  
  // Timeouts (in milliseconds)
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Endpoints
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String userAddresses = '/user/addresses';
  
  // Customer endpoints
  static const String home = '/customer/home';
  static const String vendors = '/customer/vendors';
  static const String vendorDetail = '/customer/vendors/'; // Append vendor ID
  static const String products = '/customer/products';
  static const String productDetail = '/customer/products/'; // Append product ID
  static const String cart = '/customer/cart';
  static const String checkout = '/customer/checkout';
  static const String orders = '/customer/orders';
  static const String orderDetail = '/customer/orders/'; // Append order ID
  
  // Bakery owner endpoints
  static const String bakeryDashboard = '/bakery/dashboard';
  static const String bakeryProducts = '/bakery/products';
  static const String bakeryProductDetail = '/bakery/products/'; // Append product ID
  static const String bakeryCategories = '/bakery/categories';
  static const String bakeryCategoryDetail = '/bakery/categories/'; // Append category ID
  static const String bakeryOrders = '/bakery/orders';
  static const String bakeryOrderDetail = '/bakery/orders/'; // Append order ID
  static const String bakeryProfile = '/bakery/profile';
  
  // Restaurant owner endpoints
  static const String restaurantDashboard = '/restaurant/dashboard';
  static const String restaurantProducts = '/restaurant/products';
  static const String restaurantProductDetail = '/restaurant/products/'; // Append product ID
  static const String restaurantCategories = '/restaurant/categories';
  static const String restaurantCategoryDetail = '/restaurant/categories/'; // Append category ID
  static const String restaurantOrders = '/restaurant/orders';
  static const String restaurantOrderDetail = '/restaurant/orders/'; // Append order ID
  static const String restaurantProfile = '/restaurant/profile';
}
