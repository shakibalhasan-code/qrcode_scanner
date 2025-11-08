import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/controllers/auth_controller.dart';
import 'package:qr_code_inventory/app/core/services/auth_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    debugPrint('🎯 AuthBinding.dependencies() started');

    try {
      // Initialize token storage first
      debugPrint('🔧 Initializing TokenStorage...');
      Get.put<TokenStorage>(TokenStorage(), permanent: true);
      debugPrint('✅ TokenStorage initialized');

      // Initialize auth service
      debugPrint('🔧 Initializing AuthService...');
      Get.put<AuthService>(AuthService(), permanent: true);
      debugPrint('✅ AuthService initialized');

      // Register the AuthController as a Singleton (one instance for the entire app)
      debugPrint('🔧 Registering AuthController...');
      Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
      debugPrint('✅ AuthController registered');

      debugPrint('🎉 All dependencies registered successfully');
    } catch (e) {
      debugPrint('🔥 Error in AuthBinding dependencies: ${e.toString()}');
      debugPrint('🔍 Exception type: ${e.runtimeType}');
    }

    debugPrint('🎯 AuthBinding.dependencies() completed');
  }
}
