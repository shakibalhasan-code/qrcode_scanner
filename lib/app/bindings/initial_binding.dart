import 'package:get/get.dart';
import 'package:qr_code_inventory/app/controllers/app_controller.dart';
import 'package:qr_code_inventory/app/core/services/category_service.dart';
import 'package:qr_code_inventory/app/core/services/product_service.dart';
import 'package:qr_code_inventory/app/core/services/wishlist_service.dart';
import 'package:qr_code_inventory/app/core/services/user_service.dart';
import 'package:qr_code_inventory/app/core/services/cart_service.dart';
import 'package:qr_code_inventory/app/core/services/notification_service.dart';
import 'package:qr_code_inventory/app/core/services/assign_product_service.dart';
import 'package:qr_code_inventory/app/core/services/auth_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/core/services/order_service.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/controller/dashboard_controller.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/controllers/initial_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize core auth services that should be available throughout the app
    Get.put<TokenStorage>(TokenStorage(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);

    // Controllers
    Get.lazyPut<AppController>(() => AppController(), fenix: true);
    Get.lazyPut<InitialController>(() => InitialController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);

    // Services
    Get.lazyPut<CategoryService>(() => CategoryService(), fenix: true);
    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);
    Get.lazyPut<WishlistService>(() => WishlistService(), fenix: true);
    Get.lazyPut<UserService>(() => UserService(), fenix: true);
    Get.lazyPut<CartService>(() => CartService(), fenix: true);
    Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
    Get.lazyPut<OrderService>(() => OrderService(), fenix: true);
    Get.lazyPut<AssignProductService>(
      () => AssignProductService(),
      fenix: true,
    );
  }
}
