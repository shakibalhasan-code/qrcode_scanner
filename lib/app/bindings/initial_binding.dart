import 'package:get/get.dart';
import 'package:qr_code_inventory/app/bindings/auth_binding.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/controller/dashboard_controller.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/controllers/initial_controller.dart';
import 'package:qr_code_inventory/app/views/main/search/controller/search_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize all bindings here
    AuthBinding().dependencies();
    Get.lazyPut(()=> InitialController());
    Get.lazyPut(()=> DashboardController());
    Get.lazyPut(()=> ProductSearchController());

    // Add other bindings as your app grows
    // Example: HomeBinding().dependencies();
    // Example: InventoryBinding().dependencies();
  }
}
