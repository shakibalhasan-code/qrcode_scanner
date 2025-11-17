class ApiEndpoints {
  // Base URL - Replace with your actual API URL
  static const String baseUrl = 'http://10.10.12.25:5008/api/v1';

  // Auth Endpoints
  static const String createUser = '$baseUrl/user/create-user';
  static const String login = '$baseUrl/auth/login';
  static const String verifyEmail = '$baseUrl/auth/verify-email';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String changePassword = '$baseUrl/auth/change-password';

  // Personalization Endpoints
  static const String createPersonalization = '$baseUrl/personalization/create';

  // Category Endpoints
  static const String getAllCategories = '$baseUrl/category/get-all';

  // Product Endpoints
  static const String getAllProducts = '$baseUrl/product/get-all-products';
  static const String getProductDetails = '$baseUrl/product/get-details';

  // Wishlist Endpoints
  static const String addToWishlist = '$baseUrl/wishlist/add-to-wishlist';
  static const String removeFromWishlist =
      '$baseUrl/wishlist/remove-from-wishlist';
  static const String getAllWishlists = '$baseUrl/wishlist/get-all-wishlists';

  // User Profile Endpoints
  static const String getUserProfile = '$baseUrl/user/profile';
  static const String updateUserProfile = '$baseUrl/user/update-profile';

  // Notification Endpoints
  static const String getNotifications =
      '$baseUrl/notification/get-notification';
  static const String updateNotification =
      '$baseUrl/notification/update-notification';

  // Review Endpoints
  static const String createReview = '$baseUrl/review/create-review';

  // Image Base URL
  static const String imageBaseUrl = 'http://10.10.12.25:5008';

  // Additional endpoints can be added here as needed
}
