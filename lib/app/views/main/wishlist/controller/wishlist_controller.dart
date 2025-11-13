import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/wishlist_model.dart';
import 'package:qr_code_inventory/app/core/services/wishlist_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';

class WishlistController extends GetxController {
  final WishlistService _wishlistService = Get.find<WishlistService>();
  final TokenStorage _tokenStorage = Get.find<TokenStorage>();

  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final wishlistItems = <WishlistItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Please login to view wishlist');
      }

      final response = await _wishlistService.getAllWishlists(token: token);

      if (response.success) {
        wishlistItems.assignAll(response.data.result);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('Error fetching wishlist: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to modify wishlist',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
        return;
      }

      final response = await _wishlistService.removeFromWishlist(
        productId: productId,
        token: token,
      );

      if (response.success) {
        // Remove from local list
        wishlistItems.removeWhere((item) => item.product.id == productId);

        Get.snackbar(
          'Removed',
          'Product removed from wishlist',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade800,
          duration: const Duration(seconds: 2),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('Error removing from wishlist: $e');
      Get.snackbar(
        'Error',
        'Failed to remove from wishlist: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> refreshWishlist() async {
    await fetchWishlist();
  }

  void navigateToProductDetails(WishlistItem item) {
    // Navigate to ProductDetailsView with product data
    Get.to(
      () => const ProductDetailsView(),
      arguments: item.product,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}
