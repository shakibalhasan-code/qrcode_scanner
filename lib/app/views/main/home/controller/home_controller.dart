import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/utils/app_images.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/core/services/category_service.dart';
import 'package:qr_code_inventory/app/core/services/product_service.dart';
import 'package:qr_code_inventory/app/core/services/wishlist_service.dart';
import 'package:qr_code_inventory/app/core/services/user_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/core/models/user_model.dart';
import 'package:qr_code_inventory/app/views/main/home/sub_screen/special_product_screen.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';

class HomeController extends GetxController {
  // Services
  late CategoryService categoryService;
  late ProductService productService;
  late WishlistService wishlistService;
  late UserService userService;
  late TokenStorage tokenStorage;

  // User info
  final userProfile = Rxn<User>();
  final userName = 'User'.obs;
  final greeting = 'Happy Shopping'.obs;
  final isUserLoading = false.obs;

  // Search functionality
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  // Categories data
  final categories = <Category>[].obs;
  var isCategoriesLoading = false.obs;

  // Products data
  final products = <Product>[].obs;
  var isProductsLoading = false.obs;

  // Wishlist tracking
  final wishlistProductIds = <String>[].obs;
  final isWishlistLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    categoryService = Get.find<CategoryService>();
    productService = Get.find<ProductService>();
    wishlistService = Get.find<WishlistService>();
    userService = Get.find<UserService>();
    tokenStorage = Get.find<TokenStorage>();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    // Load categories from API
    loadCategories();

    // Load products from API
    loadProducts();

    // Load user profile from API
    loadUserProfile();

    // Load wishlist from API
    loadWishlist();
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

  // Toggle wishlist status with API call
  Future<void> toggleFavorite(String productId) async {
    try {
      final token = tokenStorage.getAccessToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to add items to wishlist',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
        return;
      }

      if (wishlistProductIds.contains(productId)) {
        // Remove from wishlist
        final response = await wishlistService.removeFromWishlist(
          productId: productId,
          token: token,
        );

        if (response.success) {
          wishlistProductIds.remove(productId);
          Get.snackbar(
            'Removed',
            'Product removed from wishlist',
            backgroundColor: Colors.orange.shade100,
            colorText: Colors.orange.shade800,
            duration: const Duration(seconds: 1),
          );
        } else {
          throw Exception(response.message);
        }
      } else {
        // Add to wishlist
        final response = await wishlistService.addToWishlist(
          productId: productId,
          token: token,
        );

        if (response.success) {
          wishlistProductIds.add(productId);
          Get.snackbar(
            'Added',
            'Product added to wishlist',
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
            duration: const Duration(seconds: 1),
          );
        } else {
          throw Exception(response.message);
        }
      }

      update(); // Notify GetBuilder to rebuild
    } catch (e) {
      debugPrint('Error toggling wishlist: $e');
      Get.snackbar(
        'Error',
        'Failed to update wishlist',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 2),
      );
    }
  }

  bool isFavorite(String productId) {
    return wishlistProductIds.contains(productId);
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

  // Load wishlist from API
  Future<void> loadWishlist() async {
    debugPrint('❤️ Loading wishlist from API');

    try {
      isWishlistLoading.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        debugPrint('❌ No token found for loading wishlist');
        return;
      }

      final response = await wishlistService.getAllWishlists(token: token);

      if (response.success) {
        wishlistProductIds.clear();
        for (var item in response.data.result) {
          wishlistProductIds.add(item.product.id);
        }
        debugPrint('✅ Loaded ${wishlistProductIds.length} wishlist items');
        update(); // Notify GetBuilder to rebuild
      } else {
        debugPrint('❌ Failed to load wishlist: ${response.message}');
      }
    } catch (e) {
      debugPrint('💥 Exception in loadWishlist: $e');
    } finally {
      isWishlistLoading.value = false;
    }
  }

  // Load user profile from API
  Future<void> loadUserProfile() async {
    debugPrint('👤 Loading user profile from API');
    
    try {
      isUserLoading.value = true;
      
      final token = tokenStorage.getAccessToken();
      if (token == null) {
        debugPrint('❌ No token found for loading user profile');
        // Try to load from storage as fallback
        _loadUserFromStorage();
        return;
      }
      
      final response = await userService.getUserProfile(token: token);
      
      if (response.success) {
        userProfile.value = response.data;
        userName.value = response.data.displayName;
        debugPrint('✅ User profile loaded: ${userName.value}');
        
        // Update storage with latest data
        await tokenStorage.saveUserData(response.data.toJson());
        
        update(); // Notify GetBuilder to rebuild
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('💥 Exception in loadUserProfile: $e');
      // Fallback to storage
      _loadUserFromStorage();
    } finally {
      isUserLoading.value = false;
    }
  }

  // Load user info from storage as fallback
  void _loadUserFromStorage() {
    debugPrint('👤 Loading user info from storage (fallback)');
    try {
      final userData = tokenStorage.getUserData();
      if (userData != null) {
        if (userData['name'] != null) {
          userName.value = userData['name'];
          // Try to create User object from stored data
          try {
            userProfile.value = User.fromJson(userData);
          } catch (e) {
            debugPrint('⚠️ Could not parse stored user data: $e');
          }
        }
        debugPrint('✅ User name loaded from storage: ${userName.value}');
      } else {
        debugPrint('⚠️ No user data found in storage');
        userName.value = 'User';
      }
    } catch (e) {
      debugPrint('💥 Error loading user info from storage: $e');
      userName.value = 'User';
    }
  }
  
  // Method to refresh user profile
  Future<void> refreshUserProfile() async {
    await loadUserProfile();
  }
}
