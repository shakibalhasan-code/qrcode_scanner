import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/categories/controller/category_controller.dart';
import 'package:qr_code_inventory/app/core/services/category_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure CategoryService and TokenStorage are available
    // These should already be initialized in InitialBinding
    if (!Get.isRegistered<CategoryService>()) {
      Get.put<CategoryService>(CategoryService(), permanent: true);
    }

    if (!Get.isRegistered<TokenStorage>()) {
      Get.put<TokenStorage>(TokenStorage(), permanent: true);
    }

    // Initialize CategoryController
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}
