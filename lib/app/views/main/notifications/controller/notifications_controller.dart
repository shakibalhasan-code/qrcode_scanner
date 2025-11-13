import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/notification_model.dart';

// Legacy NotificationsController - No longer used
// The notifications view now uses the API-based NotificationController from /app/controllers/notification_controller.dart
// This file is kept for backward compatibility but is not actively used
class NotificationsController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  // Group notifications by date
  Map<String, List<NotificationItem>> get groupedNotifications {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, List<NotificationItem>> grouped = {};

    for (var notification in notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      String dateKey;
      if (notificationDate == today) {
        dateKey = 'Today';
      } else if (notificationDate == yesterday) {
        dateKey = 'Yesterday';
      } else {
        dateKey = 'Yesterday'; // Simplified for this example
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

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

  void onBackPressed() {
    Get.back();
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((item) => item.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(read: true);
      notifications.refresh();
    }
  }

  void onNotificationTap(NotificationItem notification) {
    // Mark as read when tapped
    markAsRead(notification.id);

    // Handle notification tap (navigate to product, offer page, etc.)
    Get.snackbar(
      'Notification',
      'Opened: ${notification.text}',
      duration: const Duration(seconds: 2),
    );
  }

  void clearAllNotifications() {
    notifications.clear();
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((item) => item.id == notificationId);
  }
}
