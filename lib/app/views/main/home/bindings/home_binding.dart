import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/services/category_service.dart';
import 'package:qr_code_inventory/app/views/main/home/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize CategoryService if not already initialized
    if (!Get.isRegistered<CategoryService>()) {
      Get.put<CategoryService>(CategoryService(), permanent: true);
    }

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
