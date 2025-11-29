import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';
import 'package:qr_code_inventory/app/views/main/qr_scanner/controller/qr_scanner_controller.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late final MobileScannerController cameraController;
  late final QrScannerController controller;
  bool _isDisposed = false;
  bool _isNavigating = false;
  bool _cameraStarted = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(QrScannerController(), permanent: false);

    // Set callback for product found navigation
    controller.onProductFoundCallback = _stopCameraAndNavigate;

    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
    _cameraStarted = true;
  }

  @override
  void dispose() {
    debugPrint('🗑️ QR Scanner disposing...');
    _isDisposed = true;

    // Stop and dispose camera controller
    try {
      if (_cameraStarted) {
        cameraController.stop();
      }
      cameraController.dispose();
    } catch (e) {
      debugPrint('⚠️ Error disposing camera: $e');
    }

    // Delete GetX controller
    try {
      Get.delete<QrScannerController>();
    } catch (e) {
      debugPrint('⚠️ Error deleting controller: $e');
    }

    super.dispose();
  }

  void _handleBackPress() async {
    if (_isDisposed || _isNavigating) return;

    try {
      _isNavigating = true;

      // Stop camera
      if (_cameraStarted) {
        await cameraController.stop();
        _cameraStarted = false;
      }

      if (mounted && !_isDisposed) {
        Get.back();
      }
    } catch (e) {
      debugPrint('⚠️ Error during back press: $e');
      if (mounted && !_isDisposed) {
        Get.back();
      }
    }
  }

  Future<void> _stopCameraAndNavigate(Product product) async {
    if (_isNavigating || _isDisposed) return;

    try {
      _isNavigating = true;
      controller.isProcessing.value = false;

      // Stop camera before navigation
      if (_cameraStarted) {
        await cameraController.stop();
        _cameraStarted = false;
      }

      if (mounted && !_isDisposed) {
        // Navigate to product details
        await Get.to(() => const ProductDetailsView(), arguments: product);

        // Restart camera after returning if not disposed
        if (mounted && !_isDisposed) {
          try {
            await cameraController.start();
            _cameraStarted = true;
            controller.resetScanner();
          } catch (e) {
            debugPrint('⚠️ Error restarting camera: $e');
          }

          // Show success message after returning
          Get.snackbar(
            'Product Found',
            product.name,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.check_circle, color: Colors.green),
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error during navigation: $e');
      // Try to restart camera on error
      if (mounted && !_isDisposed && !_cameraStarted) {
        try {
          await cameraController.start();
          _cameraStarted = true;
        } catch (restartError) {
          debugPrint('⚠️ Error restarting camera after error: $restartError');
        }
      }
    } finally {
      _isNavigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_isDisposed && !_isNavigating) {
          _handleBackPress();
          return false;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Scanner view
            MobileScanner(
              controller: cameraController,
              onDetect: (BarcodeCapture capture) {
                if (_isNavigating || _isDisposed) return;

                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null && code.isNotEmpty) {
                    debugPrint('🔍 Scanned QR Code: $code');
                    controller.onQrCodeDetected(code);
                  }
                }
              },
            ),

            // Overlay with UI elements
            SafeArea(
              child: Column(
                children: [
                  // Top bar with back button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: _handleBackPress,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Scan Product QR Code',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Scanning frame
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          // Corner decorations
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                  left: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                  right: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                  left: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                  right: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Status display
                  Obx(
                    () => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller.isProcessing.value
                            ? Colors.blue.withOpacity(0.9)
                            : Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.isProcessing.value)
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          else
                            const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 32,
                            ),
                          const SizedBox(height: 12),
                          Text(
                            controller.isProcessing.value
                                ? 'Processing...'
                                : controller.scannedData.value != null
                                ? 'Scanned: ${controller.scannedData.value}'
                                : 'Point camera at QR code',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
