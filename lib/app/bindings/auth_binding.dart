import 'package:get/get.dart';
import 'package:qr_code_inventory/app/controllers/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Register the AuthController as a Singleton (one instance for the entire app)
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
