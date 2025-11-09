import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';
import 'package:qr_code_inventory/app/core/utils/app_images.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';

class ProductSearchController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final searchResults = <Product>[].obs;

  // Using a list to handle multiple selections as per the UI
  final selectedCategories = <String>[
    'Mug',
    'Beauty & Personal Care',
    'Sports & Outdoor',
  ].obs;
  final favoriteProducts = <String>[].obs;

  // Sample data
  final allProducts = <Product>[
    Product(
      id: '1',
      name: 'UNIQLO AIRism Oversized T-Shirt – Unisex',
      image: AppImages.bag,
      price: '19.00',
      size: 'Large',
      status: 'active',
      qrId: 'QR001',
      category: Category(id: 'clothing', name: 'Clothing', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: 4.8,
      isFavorite: true,
    ),
    Product(
      id: '2',
      name: 'Levi\'s 511 Slim Fit Jeans – Dark Indigo',
      image: AppImages.cats,
      price: '69.00',
      size: 'Medium',
      status: 'active',
      qrId: 'QR002',
      category: Category(id: 'clothing', name: 'Clothing', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: 4.7,
    ),
    Product(
      id: '3',
      name: 'H&M Ribbed Crop Top – Soft Beige',
      image: AppImages.key,
      price: '14.99',
      size: 'Small',
      status: 'active',
      qrId: 'QR003',
      category: Category(id: 'clothing', name: 'Clothing', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: 4.6,
    ),
    Product(
      id: '4',
      name: 'ZARA Oversized Linen Blazer – Earth Tone',
      image: AppImages.mug,
      price: '89.00',
      size: 'Large',
      status: 'active',
      qrId: 'QR004',
      category: Category(id: 'clothing', name: 'Clothing', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: 4.9,
      isFavorite: true,
    ),
    Product(
      id: '5',
      name: 'Smart Keychains',
      image: AppImages.sale,
      price: '25.00',
      size: 'Small',
      status: 'active',
      qrId: 'QR005',
      category: Category(id: 'accessories', name: 'Accessories', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: 4.5,
    ),
    Product(
      id: '6',
      name: 'Leather Keychains - Set of 3',
      image: AppImages.salstrawe,
      price: '120.00',
      size: 'Small',
      status: 'active',
      qrId: 'QR006',
      category: Category(id: 'accessories', name: 'Accessories', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: 4.8,
    ),
  ].obs;

  // Price range for filter
  final priceRangeStart = 0.0.obs;
  final priceRangeEnd = 2000.0.obs;

  void setPriceRange(double start, double end) {
    priceRangeStart.value = start;
    priceRangeEnd.value = end;
    update();
  }

  // Rating for filter
  final selectedRating = '3.5+'.obs;
  void setRating(String rating) {
    selectedRating.value = rating;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    searchResults.assignAll(allProducts);
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

  void _performSearch() {
    if (searchQuery.value.isEmpty) {
      searchResults.assignAll(allProducts);
    } else {
      final query = searchQuery.value.toLowerCase();
      final filtered = allProducts.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
      searchResults.assignAll(filtered);
    }
  }

  void toggleFavorite(String productId) {
    if (favoriteProducts.contains(productId)) {
      favoriteProducts.remove(productId);
    } else {
      favoriteProducts.add(productId);
    }
    update();
  }

  bool isFavorite(String productId) => favoriteProducts.contains(productId);

  void clearFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedCategories.clear();
    searchResults.assignAll(allProducts);
    update();
  }

  void onProductTap(Product product) {
    Get.to(
      () => const ProductDetailsView(),
      arguments: product,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void toggleCategorySelection(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    _filterByCategory();
    update();
  }

  void _filterByCategory() {
    if (selectedCategories.isEmpty ||
        selectedCategories.contains('All Categories')) {
      searchResults.assignAll(allProducts);
    } else {
      final categoryIds = selectedCategories
          .map((name) => _getCategoryId(name))
          .toList();
      searchResults.value = allProducts.where((product) {
        return categoryIds.contains(product.category.id.toLowerCase());
      }).toList();
    }
  }

  String _getCategoryId(String displayName) {
    // This mapping logic can be improved based on your data model
    switch (displayName) {
      case 'Electronics':
        return 'electronics';
      case 'Hat':
        return 'accessories';
      case 'mart Keychains':
        return 'accessories';
      case 'Mug':
        return 'accessories';
      case 'Beauty & Personal Care':
        return 'beauty';
      case 'Sports & Outdoor':
        return 'sports';
      default:
        return 'all';
    }
  }

  void onBackPressed() => Get.back();

  void applyFilters() {
    _filterByCategory();
    Get.back(); // Close the drawer
  }
}
