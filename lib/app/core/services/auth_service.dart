import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../api_endpoints.dart';
import '../models/auth_response.dart';
import '../models/personalization_model.dart';

class AuthService extends GetxService {
  final http.Client _httpClient = http.Client();

  // Create Account / Sign Up
  Future<AuthResponse> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    debugPrint('🚀 AuthService.createUser() called');
    debugPrint('📧 Email: $email');
    debugPrint('👤 Name: $name');
    debugPrint('🔗 URL: ${ApiEndpoints.createUser}');

    try {
      final requestBody = {'name': name, 'email': email, 'password': password};
      debugPrint('📦 Request body: ${jsonEncode(requestBody)}');

      final response = await _httpClient.post(
        Uri.parse(ApiEndpoints.createUser),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('📈 Response status code: ${response.statusCode}');
      debugPrint('📄 Response body: ${response.body}');
      debugPrint('📋 Response headers: ${response.headers}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        debugPrint('✅ Create user successful');
        debugPrint('🎉 Success: ${authResponse.success}');
        debugPrint('💬 Message: ${authResponse.message}');
        return authResponse;
      } else {
        debugPrint('❌ Create user failed with status: ${response.statusCode}');
        debugPrint('💥 Error response: ${response.body}');

        // Try to parse error response to get clean message
        try {
          final errorResponse = jsonDecode(response.body);
          String errorMessage = 'Failed to create account';

          if (errorResponse is Map<String, dynamic>) {
            if (errorResponse.containsKey('message')) {
              errorMessage = errorResponse['message'];
            } else if (errorResponse.containsKey('error')) {
              errorMessage = errorResponse['error'];
            } else if (errorResponse.containsKey('errorMessages')) {
              // Handle validation errors
              final errors = errorResponse['errorMessages'];
              if (errors is List && errors.isNotEmpty) {
                errorMessage = errors.first['message'] ?? 'Validation error';
              }
            }
          }

          return AuthResponse(success: false, message: errorMessage);
        } catch (parseError) {
          debugPrint('Failed to parse error response: $parseError');
          return AuthResponse(
            success: false,
            message: 'Failed to create account. Please try again.',
          );
        }
      }
    } catch (e) {
      debugPrint('🔥 Exception in createUser: ${e.toString()}');
      debugPrint('🔍 Exception type: ${e.runtimeType}');
      return AuthResponse(success: false, message: 'Error: ${e.toString()}');
    }
  }

  // Login
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    debugPrint('🚀 AuthService.login() called');
    debugPrint('📧 Email: $email');
    debugPrint('🔗 URL: ${ApiEndpoints.login}');

    try {
      final requestBody = {'email': email, 'password': password};
      debugPrint('📦 Request body: ${jsonEncode(requestBody)}');

      final response = await _httpClient.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('📈 Response status code: ${response.statusCode}');
      debugPrint('📄 Response body: ${response.body}');
      debugPrint('📋 Response headers: ${response.headers}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        debugPrint('✅ Login successful');
        debugPrint('🎉 Success: ${loginResponse.success}');
        debugPrint('💬 Message: ${loginResponse.message}');
        debugPrint(
          '🔑 Access token received: ${loginResponse.data.accessToken.isNotEmpty}',
        );
        debugPrint(
          '🔄 Refresh token received: ${loginResponse.data.refreshToken.isNotEmpty}',
        );
        debugPrint(
          '👤 User data: ${loginResponse.data.user.name} - ${loginResponse.data.user.email}',
        );
        return loginResponse;
      } else {
        debugPrint('❌ Login failed with status: ${response.statusCode}');
        debugPrint('💥 Error response: ${response.body}');

        // Try to parse error response to get clean message
        try {
          final errorResponse = jsonDecode(response.body);
          String errorMessage = 'Login failed';

          if (errorResponse is Map<String, dynamic>) {
            if (errorResponse.containsKey('message')) {
              errorMessage = errorResponse['message'];
            } else if (errorResponse.containsKey('error')) {
              errorMessage = errorResponse['error'];
            }
          }

          throw Exception(errorMessage);
        } catch (parseError) {
          debugPrint('Failed to parse error response: $parseError');
          throw Exception('Login failed. Please check your credentials.');
        }
      }
    } catch (e) {
      debugPrint('🔥 Exception in login: ${e.toString()}');
      debugPrint('🔍 Exception type: ${e.runtimeType}');
      rethrow;
    }
  }

  // Verify Email with OTP
  Future<AuthResponse> verifyEmail({
    required String email,
    required int oneTimeCode,
  }) async {
    debugPrint('🚀 AuthService.verifyEmail() called');
    debugPrint('📧 Email: $email');
    debugPrint('🔢 OTP Code: $oneTimeCode');
    debugPrint('🔗 URL: ${ApiEndpoints.verifyEmail}');

    try {
      final requestBody = {'email': email, 'oneTimeCode': oneTimeCode};
      debugPrint('📦 Request body: ${jsonEncode(requestBody)}');

      final response = await _httpClient.post(
        Uri.parse(ApiEndpoints.verifyEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('📈 Response status code: ${response.statusCode}');
      debugPrint('📄 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        debugPrint('✅ Email verification successful');
        debugPrint('🎉 Success: ${authResponse.success}');
        debugPrint('💬 Message: ${authResponse.message}');
        return authResponse;
      } else {
        debugPrint(
          '❌ Email verification failed with status: ${response.statusCode}',
        );
        debugPrint('💥 Error response: ${response.body}');
        return AuthResponse(
          success: false,
          message:
              'Email verification failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('🔥 Exception in verifyEmail: ${e.toString()}');
      debugPrint('🔍 Exception type: ${e.runtimeType}');
      return AuthResponse(success: false, message: 'Error: ${e.toString()}');
    }
  }

  // Forgot Password - Send Reset Email
  Future<AuthResponse> forgotPassword({required String email}) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(ApiEndpoints.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else {
        return AuthResponse(
          success: false,
          message: 'Failed to send reset email: ${response.statusCode}',
        );
      }
    } catch (e) {
      return AuthResponse(success: false, message: 'Error: ${e.toString()}');
    }
  }

  // Reset Password with Token
  Future<AuthResponse> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(ApiEndpoints.resetPassword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else {
        return AuthResponse(
          success: false,
          message: 'Password reset failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      return AuthResponse(success: false, message: 'Error: ${e.toString()}');
    }
  }

  // Change Password
  Future<AuthResponse> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(ApiEndpoints.changePassword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else {
        return AuthResponse(
          success: false,
          message: 'Failed to change password: ${response.statusCode}',
        );
      }
    } catch (e) {
      return AuthResponse(success: false, message: 'Error: ${e.toString()}');
    }
  }

  // Create Personalization Profile
  Future<PersonalizationResponse> createPersonalization({
    required String category,
    required String email,
    required String name,
    required DateTime birthday,
    required String token,
  }) async {
    debugPrint('🚀 AuthService.createPersonalization() called');
    debugPrint('📧 Email: $email');
    debugPrint('👤 Name: $name');
    debugPrint('📅 Birthday: ${birthday.toIso8601String()}');
    debugPrint('🏷️ Category: $category');
    debugPrint('🔗 URL: ${ApiEndpoints.createPersonalization}');

    try {
      final requestBody = {
        'category': category,
        'email': email,
        'name': name,
        'birthday': birthday.toIso8601String(),
      };

      debugPrint('📦 Request Body: ${jsonEncode(requestBody)}');

      final response = await _httpClient.post(
        Uri.parse(ApiEndpoints.createPersonalization),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Personalization created successfully');
        return PersonalizationResponse.fromJson(responseData);
      } else {
        debugPrint(
          '❌ Failed to create personalization: ${response.statusCode}',
        );
        final errorData = jsonDecode(response.body);
        return PersonalizationResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to create personalization: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in createPersonalization: $e');
      return PersonalizationResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }
}
