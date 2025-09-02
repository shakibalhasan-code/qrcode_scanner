import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/utils/app_images.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/views/main/categories/categories_view.dart';
import 'package:qr_code_inventory/app/views/main/home/sub_screen/special_product_screen.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';

class HomeController extends GetxController {
  // User info
  final userName = 'Alexander Putra !'.obs;
  final greeting = 'Happy Shopping'.obs;

  // Search functionality
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  // Categories data
  final categories = <Category>[
    Category(id: '1', name: 'Hat', image: AppImages.straw),
    Category(id: '2', name: 'Mug', image: AppImages.mug),
    Category(id: '3', name: 'Kitchen', image: AppImages.supplies),
    Category(id: '4', name: 'Keychains', image: AppImages.key),
    Category(id: '5', name: 'Bag', image: AppImages.bag),
  ].obs;

  // Special products data
  final specialProducts = <Product>[
    Product(
      id: '1',
      name: 'New Balance Hat Core Sneakers',
      image: AppImages.straw,
      price: 95.00,
      isSpecial: true,
    ),
    Product(
      id: '2',
      name: 'The Ordinary Sale Products',
      image: AppImages.sale,
      price: 10.00,
      isSpecial: true,
    ),
    Product(
      id: '3',
      name: 'Smart Tag Keychains 2 - Pack of 2',
      image: AppImages.key,
      price: 60.00,
      isSpecial: true,
    ),
    Product(
      id: '4',
      name: 'Clarks Leather Crossbody Bag',
      image: AppImages.bag,
      price: 140.00,
      isSpecial: true,
    ),
  ].obs;

  // Favorites tracking
  final favoriteProducts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
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
    Get.to(() => const CategoriesView());
  }

  void onSeeAllSpecialProducts() {
    Get.to(SpecialProductScreen());
  }
}
