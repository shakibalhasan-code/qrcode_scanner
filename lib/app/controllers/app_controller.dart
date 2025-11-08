import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';

class AppController extends GetxController {
  late TokenStorage tokenStorage;
  var isLoading = true.obs;
  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 AppController.onInit() - Checking authentication status');
    tokenStorage = Get.find<TokenStorage>();
    checkAuthenticationStatus();
  }

  Future<void> checkAuthenticationStatus() async {
    try {
      debugPrint('🔍 Checking authentication status...');

      // Give a small delay to ensure GetStorage is fully initialized
      await Future.delayed(const Duration(milliseconds: 500));

      final token = tokenStorage.getAccessToken();
      final refreshToken = tokenStorage.getRefreshToken();
      final isLoggedIn = tokenStorage.isLoggedIn();

      debugPrint('🎫 Token exists: ${token != null}');
      debugPrint('🔄 Refresh token exists: ${refreshToken != null}');
      debugPrint('✅ Is logged in: $isLoggedIn');

      if (token != null && token.isNotEmpty) {
        debugPrint('✅ User is authenticated - navigating to dashboard');
        isAuthenticated.value = true;

        // Navigate to dashboard
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        debugPrint('❌ User is not authenticated - staying on login');
        isAuthenticated.value = false;

        // Stay on login screen (current route)
        if (Get.currentRoute != Routes.LOGIN) {
          Get.offAllNamed(Routes.LOGIN);
        }
      }
    } catch (e) {
      debugPrint('💥 Error checking authentication: $e');
      isAuthenticated.value = false;
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
      debugPrint('🏁 Authentication check completed');
    }
  }

  void logout() async {
    try {
      debugPrint('🚪 Logging out user...');
      await tokenStorage.clearAll();
      isAuthenticated.value = false;
      Get.offAllNamed(Routes.LOGIN);
      debugPrint('✅ Logout completed');
    } catch (e) {
      debugPrint('💥 Error during logout: $e');
    }
  }

  void onLoginSuccess() {
    debugPrint('🎉 Login successful - updating authentication status');
    isAuthenticated.value = true;
  }
}
