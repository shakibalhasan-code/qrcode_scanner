import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/services/qr_scanner_services.dart';

class QrController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> scanQrCode() async {
    // Implementation for scanning QR code
    await QrScannerServices().scanQrCode();
  }
}
