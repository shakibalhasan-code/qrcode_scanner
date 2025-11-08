import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';
import 'package:qr_code_inventory/app/core/services/category_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';

class CategoryController extends GetxController {
  // Services
  late CategoryService categoryService;
  late TokenStorage tokenStorage;

  // Observable variables
  var isLoading = false.obs;
  var categories = <Category>[].obs;
  var filteredCategories = <Category>[].obs;
  var searchText = ''.obs;
  var selectedCategory = Rxn<Category>();

  // Controllers
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 CategoryController.onInit() started');

    categoryService = Get.find<CategoryService>();
    tokenStorage = Get.find<TokenStorage>();

    loadCategories();

    // Listen to search text changes
    searchController.addListener(() {
      searchText.value = searchController.text;
      filterCategories();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Load all categories
  Future<void> loadCategories() async {
    debugPrint('🔄 Loading categories...');

    try {
      isLoading.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        debugPrint('❌ No token found');
        Get.snackbar(
          'Error',
          'Please login first',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await categoryService.getAllCategories(token: token);

      if (response.success) {
        categories.value = response.data.result;
        filteredCategories.value = response.data.result;
        debugPrint('✅ Loaded ${categories.length} categories');
      } else {
        debugPrint('❌ Failed to load categories: ${response.message}');
        Get.snackbar(
          'Error',
          'Failed to load categories: ${response.message}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in loadCategories: $e');
      Get.snackbar(
        'Error',
        'Failed to load categories: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter categories based on search text
  void filterCategories() {
    if (searchText.value.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories.where((category) {
        return category.name.toLowerCase().contains(
          searchText.value.toLowerCase(),
        );
      }).toList();
    }
    debugPrint('🔍 Filtered categories: ${filteredCategories.length}');
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    filteredCategories.value = categories;
  }

  // Select category
  void selectCategory(Category category) {
    selectedCategory.value = category;
    debugPrint('🏷️ Selected category: ${category.name}');

    // You can navigate to category details or products here
    // For now, just show a snackbar
    Get.snackbar(
      'Category Selected',
      'You selected: ${category.name}',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Refresh categories
  Future<void> refreshCategories() async {
    debugPrint('🔄 Refreshing categories...');
    await loadCategories();
  }

  // Check if category is selected
  bool isCategorySelected(Category category) {
    return selectedCategory.value?.id == category.id;
  }
}
