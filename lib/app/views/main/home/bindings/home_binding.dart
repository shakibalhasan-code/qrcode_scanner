import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/home/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
