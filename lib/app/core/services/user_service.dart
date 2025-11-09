import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../api_endpoints.dart';
import '../models/user_model.dart';

class UserService extends GetxService {
  final http.Client _httpClient = http.Client();

  // Get user profile
  Future<UserProfileResponse> getUserProfile({
    required String token,
  }) async {
    debugPrint('🚀 UserService.getUserProfile() called');
    debugPrint('🔗 URL: ${ApiEndpoints.getUserProfile}');

    try {
      final response = await _httpClient.get(
        Uri.parse(ApiEndpoints.getUserProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ User profile retrieved successfully');
        return UserProfileResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to get user profile: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 
          'Failed to get user profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in getUserProfile: $e');
      rethrow;
    }
  }

  // Update user profile with multipart PATCH method (supports image upload)
  Future<UserProfileResponse> updateUserProfile({
    required String token,
    required Map<String, dynamic> userData,
    File? profileImage,
  }) async {
    debugPrint('🚀 UserService.updateUserProfile() called');
    debugPrint('🔗 URL: ${ApiEndpoints.updateUserProfile}');
    debugPrint('📝 Data: $userData');
    debugPrint('🖼️ Has Image: ${profileImage != null}');

    try {
      // Create multipart request
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse(ApiEndpoints.updateUserProfile),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add form data fields
      userData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add image if provided
      if (profileImage != null) {
        // Get mime type
        final mimeType = lookupMimeType(profileImage.path) ?? 'image/jpeg';
        final mimeTypeData = mimeType.split('/');
        
        debugPrint('🎨 Image MIME Type: $mimeType');
        debugPrint('📁 Image Path: ${profileImage.path}');

        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // Field name for the image
            profileImage.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      // Send request
      debugPrint('📤 Sending multipart PATCH request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ User profile updated successfully');
        return UserProfileResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to update user profile: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 
          'Failed to update user profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in updateUserProfile: $e');
      rethrow;
    }
  }

  // Simple text-only profile update (without image)
  Future<UserProfileResponse> updateUserProfileData({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    debugPrint('🚀 UserService.updateUserProfileData() called');
    debugPrint('🔗 URL: ${ApiEndpoints.updateUserProfile}');
    debugPrint('📝 Data: $userData');

    try {
      final response = await _httpClient.patch(
        Uri.parse(ApiEndpoints.updateUserProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ User profile data updated successfully');
        return UserProfileResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to update user profile data: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 
          'Failed to update user profile data: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in updateUserProfileData: $e');
      rethrow;
    }
  }
}