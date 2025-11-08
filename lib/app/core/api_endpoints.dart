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

  // Additional endpoints can be added here as needed
}
