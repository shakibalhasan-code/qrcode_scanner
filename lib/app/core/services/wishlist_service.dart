import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../api_endpoints.dart';
import '../models/wishlist_model.dart';

class WishlistService extends GetxService {
  final http.Client _httpClient = http.Client();

  // Add product to wishlist
  Future<WishlistActionResponse> addToWishlist({
    required String productId,
    required String token,
  }) async {
    debugPrint('🚀 WishlistService.addToWishlist() called');
    debugPrint('🆔 Product ID: $productId');
    debugPrint('🔗 URL: ${ApiEndpoints.addToWishlist}/$productId');

    try {
      final response = await _httpClient.post(
        Uri.parse('${ApiEndpoints.addToWishlist}/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Product added to wishlist successfully');
        return WishlistActionResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to add to wishlist: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        return WishlistActionResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to add to wishlist: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in addToWishlist: $e');
      return WishlistActionResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  // Remove product from wishlist
  Future<WishlistActionResponse> removeFromWishlist({
    required String productId,
    required String token,
  }) async {
    debugPrint('🚀 WishlistService.removeFromWishlist() called');
    debugPrint('🆔 Product ID: $productId');
    debugPrint('🔗 URL: ${ApiEndpoints.removeFromWishlist}/$productId');

    try {
      final response = await _httpClient.delete(
        Uri.parse('${ApiEndpoints.removeFromWishlist}/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Product removed from wishlist successfully');
        return WishlistActionResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to remove from wishlist: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        return WishlistActionResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to remove from wishlist: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in removeFromWishlist: $e');
      return WishlistActionResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  // Get all wishlist items
  Future<WishlistListResponse> getAllWishlists({required String token}) async {
    debugPrint('🚀 WishlistService.getAllWishlists() called');
    debugPrint('🔗 URL: ${ApiEndpoints.getAllWishlists}');

    try {
      final response = await _httpClient.get(
        Uri.parse(ApiEndpoints.getAllWishlists),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Wishlist retrieved successfully');
        return WishlistListResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to get wishlist: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        return WishlistListResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to get wishlist: ${response.statusCode}',
          data: WishlistData(result: [], meta: WishlistMeta(page: 1, total: 0)),
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in getAllWishlists: $e');
      return WishlistListResponse(
        success: false,
        message: 'Error: ${e.toString()}',
        data: WishlistData(result: [], meta: WishlistMeta(page: 1, total: 0)),
      );
    }
  }

  // Check if product is in wishlist (helper method)
  Future<bool> isProductInWishlist({
    required String productId,
    required String token,
  }) async {
    try {
      final response = await getAllWishlists(token: token);
      if (response.success) {
        return response.data.result.any((item) => item.product.id == productId);
      }
      return false;
    } catch (e) {
      debugPrint('Error checking wishlist status: $e');
      return false;
    }
  }
}
