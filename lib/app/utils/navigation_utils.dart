import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationUtils {
  /// Safe navigation back that handles controller disposal gracefully
  static void safeBack() {
    try {
      if (Get.isOverlaysOpen) {
        Get.back();
        return;
      }

      if (Get.currentRoute != '/' &&
          ModalRoute.of(Get.context!)?.canPop == true) {
        Get.back();
      } else {
        // Fallback to Navigator if Get.back() fails
        if (Navigator.canPop(Get.context!)) {
          Navigator.pop(Get.context!);
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error during safe navigation back: $e');
      // Last resort fallback
      try {
        if (Navigator.canPop(Get.context!)) {
          Navigator.pop(Get.context!);
        }
      } catch (fallbackError) {
        debugPrint('⚠️ Fallback navigation also failed: $fallbackError');
      }
    }
  }

  /// Safe controller access that prevents late initialization errors
  static T? safeFind<T>() {
    try {
      return Get.find<T>();
    } catch (e) {
      debugPrint('⚠️ Controller not found: $T - $e');
      return null;
    }
  }

  /// Safe controller put that prevents conflicts
  static T safePut<T>(T controller, {String? tag, bool permanent = false}) {
    try {
      // Check if already registered
      if (Get.isRegistered<T>(tag: tag)) {
        return Get.find<T>(tag: tag);
      }
      return Get.put<T>(controller, tag: tag, permanent: permanent);
    } catch (e) {
      debugPrint('⚠️ Error putting controller: $T - $e');
      return controller;
    }
  }
}
