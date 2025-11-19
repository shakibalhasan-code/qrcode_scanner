import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/assign_product_model.dart';
import 'package:qr_code_inventory/app/core/services/assign_product_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';

class CategoryProductsController extends GetxController {
  // Services
  late AssignProductService _assignProductService;
  late TokenStorage _tokenStorage;

  // Observable variables
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final assignedProducts = <AssignProduct>[].obs;
  final totalProducts = 0.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 CategoryProductsController.onInit() started');

    _assignProductService = Get.find<AssignProductService>();
    _tokenStorage = Get.find<TokenStorage>();
  }

  /// Load products by category ID
  Future<void> loadProductsByCategory(String categoryId) async {
    debugPrint('🔄 Loading products for category: $categoryId');

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Please login to view products');
      }

      final response = await _assignProductService.getAssignProductsByCategory(
        categoryId: categoryId,
        token: token,
      );

      if (response.success) {
        assignedProducts.assignAll(response.data.assignProduct);
        totalProducts.value = response.data.meta.total;
        debugPrint(
          '✅ Loaded ${assignedProducts.length} assigned products for category',
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('❌ Error loading products for category: $e');
      hasError.value = true;
      errorMessage.value = e.toString();

      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to load products: ${e.toString()}',
        backgroundColor: Colors.red.withValues(alpha: 0.2),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle product tap navigation
  void onProductTap(AssignProduct assignedProduct) {
    debugPrint('👆 Product tapped: ${assignedProduct.productId.name}');

    // Convert AssignedProductDetails to Product model for navigation
    final product = _convertToProduct(assignedProduct.productId);

    Get.to(
      () => const ProductDetailsView(),
      arguments: product,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Convert AssignedProductDetails to Product model
  Product _convertToProduct(AssignedProductDetails assignedProduct) {
    // Create a basic Category object
    final category = Category(
      id: assignedProduct.category,
      name: 'Category', // You might want to fetch category name separately
      image: '',
    );

    return Product(
      id: assignedProduct.id,
      name: assignedProduct.name,
      image: assignedProduct.image,
      price: assignedProduct.price,
      size: assignedProduct.size,
      status: 'active',
      qrId: '',
      category: category,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      ratingStats: null,
      rating: 0.0,
      isFavorite: false,
    );
  }

  /// Check if there are any products
  bool get hasProducts => assignedProducts.isNotEmpty;

  /// Get products count
  int get productsCount => assignedProducts.length;
}
