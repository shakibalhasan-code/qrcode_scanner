import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../api_endpoints.dart';
import '../models/category_model.dart';

class CategoryService extends GetxService {
  final http.Client _httpClient = http.Client();

  // Get All Categories
  Future<CategoryResponse> getAllCategories({required String token}) async {
    debugPrint('🚀 CategoryService.getAllCategories() called');
    debugPrint('🔗 URL: ${ApiEndpoints.getAllCategories}');

    try {
      final response = await _httpClient.get(
        Uri.parse(ApiEndpoints.getAllCategories),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Categories retrieved successfully');
        return CategoryResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to get categories: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        return CategoryResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to get categories: ${response.statusCode}',
          data: CategoryData(result: [], meta: CategoryMeta(page: 1, total: 0)),
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in getAllCategories: $e');
      return CategoryResponse(
        success: false,
        message: 'Error: ${e.toString()}',
        data: CategoryData(result: [], meta: CategoryMeta(page: 1, total: 0)),
      );
    }
  }
}
