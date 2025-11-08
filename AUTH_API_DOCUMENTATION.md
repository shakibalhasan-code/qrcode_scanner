# Authentication API Documentation

This document outlines the structure and usage of the authentication system implemented in this application.

## Overview

The authentication system is built with clean architecture principles, separating concerns into:

- **API Endpoints**: `lib/app/core/api_endpoints.dart` - All API endpoint URLs
- **Models**: `lib/app/core/models/` - Data models for requests/responses
- **Services**: `lib/app/core/services/` - Business logic and API calls
- **Controller**: `lib/app/controllers/auth_controller.dart` - UI logic and state management
- **Bindings**: `lib/app/bindings/auth_binding.dart` - Dependency injection

## API Endpoints

### Base URL

Replace `{{URL}}` in `lib/app/core/api_endpoints.dart` with your actual API base URL.

```dart
static const String baseUrl = '{{URL}}';
```

### Available Endpoints

#### 1. Create Account / Sign Up

- **Endpoint**: `POST /user/create-user`
- **Body**:

```json
{
    "name": "rifat",
    "email": "rifatmiafh373@gmail.com",
    "password": "12345678"
}
```

- **Response**: `AuthResponse` with success message

#### 2. Login

- **Endpoint**: `POST /auth/login`
- **Body**:

```json
{
    "email": "rifatmiah373@gmail.com",
    "password": "12345678"
}
```

- **Response**: `LoginResponse` with access token, refresh token, and user data
- **Token Storage**: Automatically saved after successful login

#### 3. Verify Email with OTP

- **Endpoint**: `POST /auth/verify-email`
- **Body**:

```json
{
    "email": "rifatmiah373@gmail.com",
    "oneTimeCode": 846153
}
```

- **Response**: `AuthResponse` with success message

#### 4. Forgot Password

- **Endpoint**: `POST /auth/forgot-password`
- **Body**:

```json
{
    "email": "rifatmiah373@gmail.com"
}
```

- **Response**: `AuthResponse` with success message

#### 5. Reset Password

- **Endpoint**: `POST /auth/reset-password`
- **Headers**: Requires `Authorization: Bearer <token>`
- **Body**:

```json
{
    "newPassword": "11111111",
    "confirmPassword": "11111111"
}
```

- **Response**: `AuthResponse` with success message

#### 6. Change Password

- **Endpoint**: `POST /auth/change-password`
- **Headers**: Requires `Authorization: Bearer <token>`
- **Body**:

```json
{
    "currentPassword": "11111111",
    "newPassword": "44444444",
    "confirmPassword": "44444444"
}
```

- **Response**: `AuthResponse` with success message

## File Structure

```
lib/app/
├── core/
│   ├── api_endpoints.dart          # All API endpoint URLs
│   ├── models/
│   │   ├── user_model.dart         # User data model
│   │   └── auth_response.dart      # Login and auth response models
│   └── services/
│       ├── auth_service.dart       # HTTP API calls
│       └── token_storage.dart      # Token storage management
├── controllers/
│   └── auth_controller.dart        # Auth state management & logic
└── bindings/
    └── auth_binding.dart           # Dependency injection setup
```

## Usage Examples

### 1. Login Example

```dart
final authController = Get.find<AuthController>();

// Login
await authController.login();

// Access error/success messages
authController.errorMessage.value;
authController.successMessage.value;

// Check if logged in
final tokenStorage = Get.find<TokenStorage>();
bool isLoggedIn = tokenStorage.isLoggedIn();
```

### 2. Create Account Example

```dart
final authController = Get.find<AuthController>();

authController.fullNameController.text = 'John Doe';
authController.createEmailController.text = 'john@example.com';
authController.createPasswordController.text = 'password123';
authController.confirmPasswordController.text = 'password123';

await authController.createAccount();
```

### 3. Access Stored Data

```dart
final tokenStorage = Get.find<TokenStorage>();

// Get tokens
String? accessToken = tokenStorage.getAccessToken();
String? refreshToken = tokenStorage.getRefreshToken();

// Get user data
Map<String, dynamic>? userData = tokenStorage.getUserData();

// Logout
await tokenStorage.clearAll();
```

### 4. Reactive UI Binding

```dart
Obx(() {
  if (authController.isLoading.value) {
    return CircularProgressIndicator();
  }
  
  if (authController.errorMessage.value.isNotEmpty) {
    return Text(
      authController.errorMessage.value,
      style: TextStyle(color: Colors.red),
    );
  }
  
  return SizedBox.shrink();
})
```

## Token Management

### Automatic Token Saving

Tokens are automatically saved after successful login:

```dart
// In AuthService.login()
final response = await authService.login(...);
await tokenStorage.saveTokens(
  accessToken: response.data.accessToken,
  refreshToken: response.data.refreshToken,
);
```

### Token Usage in Authenticated Requests

Tokens are automatically included in headers for protected endpoints:

```dart
// For reset password and change password
headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
}
```

### Token Storage Details

- **Storage Engine**: GetStorage (local persistent storage)
- **Keys**:
  - `access_token`: JWT access token
  - `refresh_token`: JWT refresh token
  - `user_data`: User profile information
- **Persistence**: Data persists across app restarts

## Error Handling

All API calls include comprehensive error handling:

```dart
try {
  final response = await authService.login(...);
  if (response.success) {
    // Handle success
  } else {
    // Handle API error
    errorMessage.value = response.message;
  }
} catch (e) {
  // Handle network/exception error
  errorMessage.value = 'Login failed: ${e.toString()}';
}
```

## Best Practices

1. **Always dispose controllers**: Controllers automatically dispose when not needed
2. **Check authentication status**: Use `tokenStorage.isLoggedIn()` before accessing protected content
3. **Handle loading states**: Show loading indicators while API calls are in progress
4. **Display error messages**: Show user-friendly error messages from `errorMessage.obs`
5. **Validate inputs**: Form validation is built into each controller method
6. **Secure token storage**: Tokens are securely stored locally using GetStorage

## Setup Instructions

1. Update the base URL in `api_endpoints.dart`:

```dart
static const String baseUrl = 'https://your-api.com';
```

2. Ensure AuthBinding is used in your main.dart or routing:

```dart
GetPage(
  name: '/auth',
  page: () => AuthView(),
  binding: AuthBinding(),
)
```

3. Initialize GetStorage in main.dart:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}
```

## Dependencies

- `get: ^4.7.2` - State management and routing
- `http: ^1.5.0` - HTTP client for API calls
- `get_storage: ^2.1.1` - Local storage for tokens

## Future Enhancements

- [ ] Token refresh mechanism
- [ ] Biometric authentication
- [ ] Multi-factor authentication (MFA)
- [ ] Social login integration
- [ ] Remember me functionality
- [ ] Account recovery
