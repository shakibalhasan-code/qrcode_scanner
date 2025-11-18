import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/core/services/product_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';

class ProductSearchController extends GetxController {
  // Services
  late ProductService _productService;
  late TokenStorage _tokenStorage;

  // Controllers and observables
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final searchResults = <Product>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Filter selections
  final selectedCategories = <String>[].obs;
  final favoriteProducts = <String>[].obs;

  // All products data
  final allProducts = <Product>[].obs;

  // Price range for filter
  final priceRangeStart = 0.0.obs;
  final priceRangeEnd = 2000.0.obs;

  // Rating for filter
  final selectedRating = '3.5+'.obs;

  @override
  void onInit() {
    super.onInit();
    _productService = Get.find<ProductService>();
    _tokenStorage = Get.find<TokenStorage>();

    // Load products from API
    _loadProductsFromAPI();

    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _performSearch();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Load products from API
  Future<void> _loadProductsFromAPI() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Please login to view products');
      }

      final response = await _productService.getAllProducts(token: token);

      if (response.success) {
        allProducts.assignAll(response.data.result);
        searchResults.assignAll(allProducts);
        debugPrint('✅ Loaded ${allProducts.length} products from API');
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
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

  /// Perform search based on query and applied filters
  void _performSearch() {
    List<Product> filtered = allProducts.toList();

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.category.name.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by selected categories
    if (selectedCategories.isNotEmpty) {
      final categoryIds = selectedCategories
          .map((name) => _getCategoryId(name))
          .toList();
      filtered = filtered.where((product) {
        return categoryIds.contains(product.category.id.toLowerCase());
      }).toList();
    }

    // Filter by price range
    filtered = filtered.where((product) {
      final price = double.tryParse(product.price) ?? 0.0;
      return price >= priceRangeStart.value && price <= priceRangeEnd.value;
    }).toList();

    // Filter by rating
    if (selectedRating.value.isNotEmpty &&
        selectedRating.value != 'All Ratings') {
      final ratingThreshold = _getRatingThreshold(selectedRating.value);
      filtered = filtered.where((product) {
        return product.effectiveRating >= ratingThreshold;
      }).toList();
    }

    searchResults.assignAll(filtered);
    debugPrint(
      '🔍 Search results: ${searchResults.length} products (query: "${searchQuery.value}")',
    );
  }

  /// Get rating threshold from rating string (e.g., "4.5+" -> 4.5)
  double _getRatingThreshold(String rating) {
    try {
      return double.parse(rating.replaceAll('+', ''));
    } catch (e) {
      return 0.0;
    }
  }

  /// Toggle favorite status for a product
  void toggleFavorite(String productId) {
    if (favoriteProducts.contains(productId)) {
      favoriteProducts.remove(productId);
    } else {
      favoriteProducts.add(productId);
    }
    update();
  }

  /// Check if a product is favorited
  bool isFavorite(String productId) => favoriteProducts.contains(productId);

  /// Clear all filters and show all products
  void clearFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedCategories.clear();
    priceRangeStart.value = 0.0;
    priceRangeEnd.value = 2000.0;
    selectedRating.value = '3.5+';
    _performSearch();
    update();
  }

  /// Handle product tap navigation
  void onProductTap(Product product) {
    Get.to(
      () => const ProductDetailsView(),
      arguments: product,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Toggle category selection
  void toggleCategorySelection(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    _performSearch();
    update();
  }

  /// Set price range for filtering
  void setPriceRange(double start, double end) {
    priceRangeStart.value = start;
    priceRangeEnd.value = end;
    _performSearch();
    update();
  }

  /// Set rating filter
  void setRating(String rating) {
    selectedRating.value = rating;
    _performSearch();
    update();
  }

  /// Apply all filters
  void applyFilters() {
    _performSearch();
    Get.back(); // Close the drawer
  }

  /// Get category ID from display name
  String _getCategoryId(String displayName) {
    final displayNameLower = displayName.toLowerCase();
    // Try direct mapping first
    switch (displayNameLower) {
      case 'electronics':
        return 'electronics';
      case 'clothing':
        return 'clothing';
      case 'accessories':
        return 'accessories';
      case 'beauty':
      case 'beauty & personal care':
        return 'beauty';
      case 'sports':
      case 'sports & outdoor':
        return 'sports';
      default:
        return displayNameLower;
    }
  }

  /// Handle back button press
  void onBackPressed() => Get.back();
}
