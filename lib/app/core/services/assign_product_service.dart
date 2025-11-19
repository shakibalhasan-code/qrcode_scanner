import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../api_endpoints.dart';
import '../models/assign_product_model.dart';

class AssignProductService extends GetxService {
  final http.Client _httpClient = http.Client();

  // Get all assign products by category ID
  Future<AssignProductResponse> getAssignProductsByCategory({
    required String categoryId,
    required String token,
  }) async {
    debugPrint('🚀 AssignProductService.getAssignProductsByCategory() called');
    debugPrint('🏷️ Category ID: $categoryId');
    debugPrint(
      '🔗 URL: ${ApiEndpoints.getAssignProductsByCategory}/$categoryId',
    );

    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.getAssignProductsByCategory}/$categoryId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Assign products retrieved successfully');
        return AssignProductResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to get assign products: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        return AssignProductResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to get assign products: ${response.statusCode}',
          data: AssignProductData(
            assignProduct: [],
            meta: AssignProductMeta(page: 1, limit: 10, total: 0),
          ),
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in getAssignProductsByCategory: $e');
      return AssignProductResponse(
        success: false,
        message: 'Error: ${e.toString()}',
        data: AssignProductData(
          assignProduct: [],
          meta: AssignProductMeta(page: 1, limit: 10, total: 0),
        ),
      );
    }
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
