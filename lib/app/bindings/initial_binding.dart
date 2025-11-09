import 'package:get/get.dart';
import 'package:qr_code_inventory/app/bindings/auth_binding.dart';
import 'package:qr_code_inventory/app/controllers/app_controller.dart';
import 'package:qr_code_inventory/app/core/services/category_service.dart';
import 'package:qr_code_inventory/app/core/services/product_service.dart';
import 'package:qr_code_inventory/app/core/services/wishlist_service.dart';
import 'package:qr_code_inventory/app/core/services/user_service.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/controller/dashboard_controller.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/controllers/initial_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Register AuthBinding
    AuthBinding().dependencies();

    // Controllers
    Get.lazyPut<AppController>(() => AppController(), fenix: true);
    Get.lazyPut<InitialController>(() => InitialController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);

    // Services
    Get.lazyPut<CategoryService>(() => CategoryService(), fenix: true);
    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);
    Get.lazyPut<WishlistService>(() => WishlistService(), fenix: true);
    Get.lazyPut<UserService>(() => UserService(), fenix: true);
  }
}
