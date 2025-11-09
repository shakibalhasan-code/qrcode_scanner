import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../api_endpoints.dart';
import '../models/product_model.dart';

class ProductService extends GetxService {
  final http.Client _httpClient = http.Client();

  // Get All Products
  Future<ProductResponse> getAllProducts({required String token}) async {
    debugPrint('🚀 ProductService.getAllProducts() called');
    debugPrint('🔗 URL: ${ApiEndpoints.getAllProducts}');

    try {
      final response = await _httpClient.get(
        Uri.parse(ApiEndpoints.getAllProducts),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Products retrieved successfully');
        return ProductResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to get products: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        return ProductResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to get products: ${response.statusCode}',
          data: ProductData(result: [], meta: ProductMeta(page: 1, total: 0)),
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in getAllProducts: $e');
      return ProductResponse(
        success: false,
        message: 'Error: ${e.toString()}',
        data: ProductData(result: [], meta: ProductMeta(page: 1, total: 0)),
      );
    }
  }

  // Get Product Details by ID
  Future<ProductDetailsResponse> getProductDetails({
    required String productId,
    required String token,
  }) async {
    debugPrint('🚀 ProductService.getProductDetails() called');
    debugPrint('🆔 Product ID: $productId');
    debugPrint('🔗 URL: ${ApiEndpoints.getProductDetails}/$productId');

    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.getProductDetails}/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Product details retrieved successfully');
        return ProductDetailsResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to get product details: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ??
              'Failed to get product details: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in getProductDetails: $e');
      rethrow;
    }
  }
}
