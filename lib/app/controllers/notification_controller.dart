import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/notification_model.dart';
import 'package:qr_code_inventory/app/core/services/notification_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final TokenStorage _tokenStorage = Get.find<TokenStorage>();

  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final notifications = <NotificationItem>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Fetch notifications from API
  Future<void> fetchNotifications() async {
    debugPrint('📢 Fetching notifications...');

    try {
      isLoading.value = true;
      hasError.value = false;

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Please login to view notifications');
      }

      final response = await _notificationService.getNotifications(
        token: token,
      );

      if (response.success) {
        notifications.assignAll(response.data.result);
        unreadCount.value = response.data.unreadCount;
        debugPrint(
          '✅ Loaded ${notifications.length} notifications (${unreadCount.value} unread)',
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('❌ Error fetching notifications: $e');
      hasError.value = true;
      errorMessage.value = e.toString();

      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to load notifications: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  // Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    debugPrint('📖 Marking notification as read: $notificationId');

    try {
      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to mark notifications as read',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
        return;
      }

      final response = await _notificationService.updateNotification(
        notificationId: notificationId,
        token: token,
      );

      if (response.success) {
        // Update local notification state
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index] = notifications[index].copyWith(read: true);
          unreadCount.value = unreadCount.value > 0 ? unreadCount.value - 1 : 0;
          debugPrint('✅ Notification marked as read locally');
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('❌ Error marking notification as read: $e');
      Get.snackbar(
        'Error',
        'Failed to mark notification as read: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Handle notification tap
  void onNotificationTap(NotificationItem notification) {
    debugPrint('👆 Notification tapped: ${notification.text}');

    // Mark as read if not already read
    if (!notification.read) {
      markNotificationAsRead(notification.id);
    }

    // Navigate to product details if notification has a product
    if (notification.product != null) {
      Get.to(
        () => const ProductDetailsView(),
        arguments: notification.product,
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      // Show notification details or handle other navigation
      Get.snackbar(
        'Notification',
        notification.text,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Get unread notifications
  List<NotificationItem> get unreadNotifications {
    return notifications.where((notification) => !notification.read).toList();
  }

  // Get read notifications
  List<NotificationItem> get readNotifications {
    return notifications.where((notification) => notification.read).toList();
  }

  // Get recent notifications (within 24 hours)
  List<NotificationItem> get recentNotifications {
    return notifications
        .where((notification) => notification.isRecent)
        .toList();
  }

  // Check if there are any notifications
  bool get hasNotifications => notifications.isNotEmpty;

  // Check if there are any unread notifications
  bool get hasUnreadNotifications => unreadCount.value > 0;

  // Method for back navigation
  void onBackPressed() {
    Get.back();
  }

  // Get today's notifications
  List<NotificationItem> get todayNotifications {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return notifications.where((notification) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      return notificationDate == today;
    }).toList();
  }

  // Get yesterday's notifications
  List<NotificationItem> get yesterdayNotifications {
    final now = DateTime.now();
    final yesterday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 1));

    return notifications.where((notification) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      return notificationDate == yesterday;
    }).toList();
  }
}
