import 'package:get/get.dart';
import 'package:qr_code_inventory/app/bindings/auth_binding.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/controller/initial_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize all bindings here
    AuthBinding().dependencies();
    Get.lazyPut(()=> InitialController());

    // Add other bindings as your app grows
    // Example: HomeBinding().dependencies();
    // Example: InventoryBinding().dependencies();
  }
}
