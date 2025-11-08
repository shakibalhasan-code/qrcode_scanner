import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/controllers/app_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize AppController when splash screen is loaded
    Get.find<AppController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 50.sp,
              ),
            ),
            SizedBox(height: 20.h),

            // App Name
            Text(
              'QR Code Inventory',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D1F3C),
              ),
            ),
            SizedBox(height: 40.h),

            // Loading Indicator
            Obx(() {
              final appController = Get.find<AppController>();
              if (appController.isLoading.value) {
                return Column(
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 16.h),
                    Text(
                      'Checking authentication...',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
