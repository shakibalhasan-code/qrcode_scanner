import 'package:get/get.dart';
import 'package:qr_code_inventory/app/bindings/auth_binding.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize all bindings here
    AuthBinding().dependencies();
    
    // Add other bindings as your app grows
    // Example: HomeBinding().dependencies();
    // Example: InventoryBinding().dependencies();
  }
}
