import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';
import 'package:qr_code_inventory/app/views/main/home/controller/home_controller.dart';

class QrScannerController extends GetxController {
  // Observable variables
  final scannedData = Rxn<String>();
  final isProcessing = false.obs;
  final lastScannedQrId = ''.obs; // To prevent duplicate scans
  final isDisposed = false.obs; // Track disposal state

  // Callback for navigation (set by screen)
  Function(Product)? onProductFoundCallback;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 QrScannerController initialized');
  }

  @override
  void onClose() {
    debugPrint('🗑️ QrScannerController closing');
    // Mark as disposed to prevent any further operations
    isDisposed.value = true;
    // Clean up resources
    resetScanner();
    onProductFoundCallback = null;
    super.onClose();
  }

  // Handle QR code detection
  Future<void> onQrCodeDetected(String qrData) async {
    // Check if controller is disposed
    if (isDisposed.value) {
      debugPrint('⚠️ Controller is disposed, ignoring QR code');
      return;
    }

    // Prevent duplicate processing of the same QR code
    if (isProcessing.value || lastScannedQrId.value == qrData) {
      debugPrint('⚠️ Already processing this QR code or duplicate scan');
      return;
    }

    debugPrint('📱 QR Code detected: $qrData');
    scannedData.value = qrData;
    lastScannedQrId.value = qrData;
    isProcessing.value = true;

    try {
      // Check if disposed before proceeding
      if (isDisposed.value) return;

      // Find product by QR ID from home controller's product list
      final homeController = Get.find<HomeController>();
      final products = homeController.products;

      debugPrint(
        '🔍 Searching in ${products.length} products for QR ID: $qrData',
      );

      // Search for product with matching qrId
      final matchedProduct = products.firstWhereOrNull((product) {
        debugPrint(
          '  Checking product: ${product.name} (qrId: ${product.qrId}, id: ${product.id})',
        );
        return product.qrId == qrData || product.id == qrData;
      });

      // Check if disposed before handling result
      if (isDisposed.value) return;

      if (matchedProduct != null) {
        debugPrint('✅ Product found: ${matchedProduct.name}');
        await _handleProductFound(matchedProduct);
      } else {
        debugPrint('❌ No product found with QR ID: $qrData');
        _showProductNotFoundMessage(qrData);
        // Reset processing state to allow new scans
        isProcessing.value = false;
      }
    } catch (e) {
      debugPrint('💥 Error processing QR code: $e');
      if (!isDisposed.value) {
        _showErrorMessage('Failed to process QR code: ${e.toString()}');
        // Reset processing state to allow new scans
        isProcessing.value = false;
      }
    } finally {
      // Reset after a delay to allow scanning the same product again
      Future.delayed(const Duration(seconds: 3), () {
        if (!isDisposed.value) {
          lastScannedQrId.value = '';
        }
      });
    }
  }

  // Handle when product is found
  Future<void> _handleProductFound(Product product) async {
    // Check if disposed
    if (isDisposed.value) return;

    try {
      debugPrint('✅ Product found: ${product.name}');

      // Use callback to navigate (lets the screen handle camera stop)
      if (onProductFoundCallback != null) {
        onProductFoundCallback!(product);
      } else {
        // Fallback: direct navigation (less safe)
        debugPrint('⚠️ No callback set, using direct navigation');
        isProcessing.value = false;
        if (!isDisposed.value) {
          await Get.to(() => const ProductDetailsView(), arguments: product);
        }
      }
    } catch (e) {
      debugPrint('💥 Error navigating to product details: $e');
      if (!isDisposed.value) {
        _showErrorMessage('Failed to open product details: ${e.toString()}');
        isProcessing.value = false;
      }
    }
  }

  // Show error message when product is not found
  void _showProductNotFoundMessage(String qrId) {
    if (isDisposed.value) return;

    Get.snackbar(
      'Product Not Found',
      'No product matches QR ID: $qrId',
      backgroundColor: Colors.orange.withOpacity(0.1),
      colorText: Colors.orange,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning, color: Colors.orange),
      snackPosition: SnackPosition.TOP,
    );
  }

  // Show general error message
  void _showErrorMessage(String message) {
    if (isDisposed.value) return;

    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.red),
      snackPosition: SnackPosition.TOP,
    );
  }

  // Reset scanner state
  void resetScanner() {
    if (!isDisposed.value) {
      scannedData.value = null;
      lastScannedQrId.value = '';
      isProcessing.value = false;
    }
  }

  // Navigate back
  void onBackPressed() {
    if (!isDisposed.value) {
      Get.back();
    }
  }
}
