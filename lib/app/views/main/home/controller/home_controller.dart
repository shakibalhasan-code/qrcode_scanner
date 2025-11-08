import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/utils/app_images.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/core/services/category_service.dart';
import 'package:qr_code_inventory/app/core/services/product_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/views/main/home/sub_screen/special_product_screen.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';

class HomeController extends GetxController {
  // Services
  late CategoryService categoryService;
  late ProductService productService;
  late TokenStorage tokenStorage;

  // User info
  final userName = 'Alexander Putra !'.obs;
  final greeting = 'Happy Shopping'.obs;

  // Search functionality
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  // Categories data
  final categories = <Category>[].obs;
  var isCategoriesLoading = false.obs;

  // Products data
  final products = <Product>[].obs;
  var isProductsLoading = false.obs;

  // Favorites tracking
  final favoriteProducts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    categoryService = Get.find<CategoryService>();
    productService = Get.find<ProductService>();
    tokenStorage = Get.find<TokenStorage>();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    // Load categories from API
    loadCategories();

    // Load products from API
    loadProducts();

    // Load user info from storage
    loadUserInfo();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Methods
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void toggleFavorite(String productId) {
    if (favoriteProducts.contains(productId)) {
      favoriteProducts.remove(productId);
    } else {
      favoriteProducts.add(productId);
    }
    update(); // Notify GetBuilder to rebuild
  }

  bool isFavorite(String productId) {
    return favoriteProducts.contains(productId);
  }

  void onCategoryTap(Category category) {
    // Handle category tap
    Get.snackbar('Category', 'Tapped on ${category.name}');
  }

  void onProductTap(Product product) {
    Get.to(
      () => const ProductDetailsView(),
      arguments: product,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void onSeeAllCategories() {
    debugPrint('🚀 Navigating to Categories screen');
    Get.toNamed(Routes.CATEGORIES);
  }

  void onSeeAllProducts() {
    Get.to(SpecialProductScreen());
  }

  // Load categories from API
  Future<void> loadCategories() async {
    debugPrint('🚀 HomeController.loadCategories() called');

    try {
      isCategoriesLoading.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        debugPrint('❌ No token found for loading categories');
        // Load fallback categories
        _loadFallbackCategories();
        return;
      }

      final response = await categoryService.getAllCategories(token: token);

      if (response.success) {
        categories.value = response.data.result;
        debugPrint('✅ Loaded ${categories.length} categories from API');
        update(); // Notify GetBuilder to rebuild
      } else {
        debugPrint('❌ Failed to load categories: ${response.message}');
        // Load fallback categories
        _loadFallbackCategories();
      }
    } catch (e) {
      debugPrint('💥 Exception in loadCategories: $e');
      // Load fallback categories
      _loadFallbackCategories();
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  // Load fallback categories if API fails
  void _loadFallbackCategories() {
    debugPrint('📦 Loading fallback categories');
    categories.value = [
      Category(id: '1', name: 'Electronics', image: AppImages.straw),
      Category(id: '2', name: 'Accessories', image: AppImages.mug),
      Category(id: '3', name: 'Kitchen', image: AppImages.supplies),
      Category(id: '4', name: 'Keychains', image: AppImages.key),
      Category(id: '5', name: 'Bags', image: AppImages.bag),
    ];
    update();
  }

  // Load products from API
  Future<void> loadProducts() async {
    debugPrint('🚀 HomeController.loadProducts() called');

    try {
      isProductsLoading.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        debugPrint('❌ No token found for loading products');
        return;
      }

      final response = await productService.getAllProducts(token: token);

      if (response.success) {
        products.value = response.data.result;
        debugPrint('✅ Loaded ${products.length} products from API');
        update(); // Notify GetBuilder to rebuild
      } else {
        debugPrint('❌ Failed to load products: ${response.message}');
      }
    } catch (e) {
      debugPrint('💥 Exception in loadProducts: $e');
    } finally {
      isProductsLoading.value = false;
    }
  }

  // Load user info from storage
  void loadUserInfo() {
    debugPrint('👤 Loading user info from storage');
    try {
      final userData = tokenStorage.getUserData();
      if (userData != null && userData['name'] != null) {
        userName.value = userData['name'];
        debugPrint('✅ User name loaded: ${userName.value}');
      } else {
        debugPrint('⚠️ No user name found in storage');
      }
    } catch (e) {
      debugPrint('💥 Error loading user info: $e');
    }
  }
}
