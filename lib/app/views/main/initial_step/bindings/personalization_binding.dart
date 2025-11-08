import 'package:get/get.dart';
import '../controllers/personalization_controller.dart';
import '../controllers/initial_controller.dart';
import 'package:qr_code_inventory/app/core/services/auth_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';

class PersonalizationBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure services exist (they should already be initialized from AuthBinding)
    // Don't create new instances, just ensure they exist
    try {
      Get.find<TokenStorage>();
      Get.find<AuthService>();
    } catch (e) {
      // If services don't exist, create them
      Get.put<TokenStorage>(TokenStorage(), permanent: true);
      Get.put<AuthService>(AuthService(), permanent: true);
    }

    // Initialize controllers
    Get.lazyPut<PersonalizationController>(() => PersonalizationController());
    Get.put<InitialController>(InitialController());
  }
}
