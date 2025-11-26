import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/assign_product_model.dart';
import 'package:qr_code_inventory/app/core/services/assign_product_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';

class AllAssignedProductsController extends GetxController {
  // Services
  late AssignProductService _assignProductService;
  late TokenStorage _tokenStorage;

  // Observable variables
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final assignedProducts = <AssignProduct>[].obs;
  final filteredProducts = <AssignProduct>[].obs;
  final totalProducts = 0.obs;
  final searchQuery = ''.obs;

  // Controllers
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 AllAssignedProductsController.onInit() started');

    try {
      _assignProductService = Get.find<AssignProductService>();
      _tokenStorage = Get.find<TokenStorage>();

      // Load all assigned products
      loadAllAssignedProducts();

      // Listen to search changes
      searchController.addListener(() {
        searchQuery.value = searchController.text;
        _filterProducts();
      });
    } catch (e) {
      debugPrint('⚠️ Error initializing AllAssignedProductsController: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to initialize services';
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    debugPrint('🧹 Disposing AllAssignedProductsController');
    super.onClose();
  }

  /// Load all assigned products
  Future<void> loadAllAssignedProducts() async {
    debugPrint('🔄 Loading all assigned products');

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Please login to view products');
      }

      final response = await _assignProductService.getAllAssignProducts(
        token: token,
      );

      if (response.success) {
        assignedProducts.assignAll(response.data.assignProduct);
        filteredProducts.assignAll(response.data.assignProduct);
        totalProducts.value = response.data.meta.total;
        debugPrint('✅ Loaded ${assignedProducts.length} assigned products');
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('❌ Error loading all assigned products: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter products based on search query
  void _filterProducts() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredProducts.assignAll(assignedProducts);
    } else {
      filteredProducts.assignAll(
        assignedProducts.where((product) {
          final productName = product.productId.name.toLowerCase();
          final userName = product.userId.name.toLowerCase();
          final userEmail = product.userId.email.toLowerCase();

          return productName.contains(query) ||
              userName.contains(query) ||
              userEmail.contains(query);
        }).toList(),
      );
    }
  }

  /// Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredProducts.assignAll(assignedProducts);
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
      name: 'Category',
      image: '',
    );

    return Product(
      id: assignedProduct.id,
      name: assignedProduct.name,
      image: assignedProduct.image,
      price: assignedProduct.price,
      size: assignedProduct.size,
      status: assignedProduct.status ?? 'active',
      qrId: assignedProduct.qrId ?? '',
      category: category,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      ratingStats: null,
      rating: assignedProduct.rating ?? 0.0,
      isFavorite: false,
    );
  }

  /// Check if there are any products
  bool get hasProducts => filteredProducts.isNotEmpty;

  /// Get products count
  int get productsCount => filteredProducts.length;
}
