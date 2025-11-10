import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/core/services/product_service.dart';
import 'package:qr_code_inventory/app/core/services/wishlist_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/core/services/cart_service.dart';
import 'package:qr_code_inventory/app/views/main/cart/cart_view.dart';

class ProductDetailsController extends GetxController {
  Product? product;
  final ProductService _productService = Get.find<ProductService>();
  final WishlistService _wishlistService = Get.find<WishlistService>();
  final TokenStorage _tokenStorage = Get.find<TokenStorage>();
  final CartService _cartService = Get.find<CartService>();

  final isFavorite = false.obs;
  final quantity = 1.obs;
  final selectedImageIndex = 0.obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isWishlistLoading = false.obs;
  final isAddingToCart = false.obs;

  String? productId;

  @override
  void onInit() {
    super.onInit();

    // Check if we received a product or just an ID
    final arguments = Get.arguments;

    if (arguments is Product) {
      // If we have a product object, use it and fetch updated details
      product = arguments;
      productId = product!.id;
      _fetchProductDetails();
    } else if (arguments is String) {
      // If we only have a product ID, fetch the details
      productId = arguments;
      _fetchProductDetails();
    } else {
      // Handle error case
      hasError.value = true;
      errorMessage.value = 'No product information provided';
    }

    // Check if product is in favorites (you can implement your logic here)
    isFavorite.value = false; // Default to false for now
  }

  Future<void> _fetchProductDetails() async {
    if (productId == null) return;

    try {
      isLoading.value = true;
      hasError.value = false;

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _productService.getProductDetails(
        productId: productId!,
        token: token,
      );

      if (response.success) {
        product = response.data;
        // Check if product is in wishlist after loading
        await _checkWishlistStatus();
        update(); // Notify widgets to rebuild
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('Error fetching product details: $e');
      hasError.value = true;
      errorMessage.value = e.toString();

      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to load product details: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Check if product is in wishlist
  Future<void> _checkWishlistStatus() async {
    if (productId == null) return;

    try {
      final token = _tokenStorage.getAccessToken();
      if (token == null) return;

      final isInWishlist = await _wishlistService.isProductInWishlist(
        productId: productId!,
        token: token,
      );

      isFavorite.value = isInWishlist;
    } catch (e) {
      debugPrint('Error checking wishlist status: $e');
    }
  }

  // Method to refresh product details
  Future<void> refreshProductDetails() async {
    await _fetchProductDetails();
  }

  // Toggle wishlist status
  Future<void> toggleFavorite() async {
    if (productId == null) return;

    try {
      isWishlistLoading.value = true;

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to add items to wishlist',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
        return;
      }

      if (isFavorite.value) {
        // Remove from wishlist
        final response = await _wishlistService.removeFromWishlist(
          productId: productId!,
          token: token,
        );

        if (response.success) {
          isFavorite.value = false;
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
      } else {
        // Add to wishlist
        final response = await _wishlistService.addToWishlist(
          productId: productId!,
          token: token,
        );

        if (response.success) {
          isFavorite.value = true;
          Get.snackbar(
            'Added',
            'Product added to wishlist',
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
            duration: const Duration(seconds: 2),
          );
        } else {
          throw Exception(response.message);
        }
      }
    } catch (e) {
      debugPrint('Error toggling wishlist: $e');
      Get.snackbar(
        'Error',
        'Failed to update wishlist: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isWishlistLoading.value = false;
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void addToCart() {
    if (product == null) {
      Get.snackbar(
        'Error',
        'Product information not available',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    isAddingToCart.value = true;

    try {
      // Add product to cart with selected quantity
      final success = _cartService.addToCart(
        product!,
        quantity: quantity.value,
        selectedSize: null, // You can add size selection logic here
        selectedColor: null, // You can add color selection logic here
      );

      if (success) {
        // Show success message and option to go to cart
        Get.snackbar(
          'Added to Cart',
          '${product!.name} has been added to your cart',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () {
              Get.back(); // Close snackbar
              Get.to(() => const CartView());
            },
            child: const Text(
              'View Cart',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add product to cart',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isAddingToCart.value = false;
    }
  }

  void onBackPressed() {
    Get.back();
  }

  void shareProduct() {
    if (product != null) {
      Get.snackbar(
        'Share',
        'Sharing ${product!.name}',
        duration: const Duration(seconds: 1),
      );
    }
  }

  // Check if current product is in cart
  bool get isProductInCart {
    if (product == null) return false;
    return _cartService.isProductInCart(product!.id);
  }

  // Get cart items count for badge
  int get cartItemsCount {
    return _cartService.totalItems;
  }
}
