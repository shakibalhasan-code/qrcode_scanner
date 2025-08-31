import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/controller/dashboard_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
