import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/notification_model.dart';

class NotificationsController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[
    // Today's notifications
    NotificationItem(
      id: '1',
      title: 'We Have New',
      description: 'Products With Offers',
      productImage: 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500',
      originalPrice: 260.00,
      discountedPrice: 364.95,
      timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'We Have New',
      description: 'Products With Offers',
      productImage: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      originalPrice: 260.00,
      discountedPrice: 364.95,
      timestamp: DateTime.now().subtract(const Duration(minutes: 26)),
      isRead: false,
    ),
    
    // Yesterday's notifications
    NotificationItem(
      id: '3',
      title: 'We Have New',
      description: 'Products With Offers',
      productImage: 'https://images.unsplash.com/photo-1527814050087-3793815479db?w=500',
      originalPrice: 260.00,
      discountedPrice: 364.95,
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'We Have New',
      description: 'Products With Offers',
      productImage: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      originalPrice: 260.00,
      discountedPrice: 364.95,
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'We Have New',
      description: 'Products With Offers',
      productImage: 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500',
      originalPrice: 260.00,
      discountedPrice: 364.95,
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'We Have New',
      description: 'Products With Offers',
      productImage: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      originalPrice: 260.00,
      discountedPrice: 364.95,
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
  ].obs;

  // Group notifications by date
  Map<String, List<NotificationItem>> get groupedNotifications {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    Map<String, List<NotificationItem>> grouped = {};
    
    for (var notification in notifications) {
      final notificationDate = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );
      
      String dateKey;
      if (notificationDate == today) {
        dateKey = 'Today';
      } else if (notificationDate == yesterday) {
        dateKey = 'Yesterday';
      } else {
        // For older dates, you could format them differently
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
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );
      return notificationDate == today;
    }).toList();
  }

  List<NotificationItem> get yesterdayNotifications {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    
    return notifications.where((notification) {
      final notificationDate = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
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
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh();
    }
  }

  void onNotificationTap(NotificationItem notification) {
    // Mark as read when tapped
    markAsRead(notification.id);
    
    // Handle notification tap (navigate to product, offer page, etc.)
    Get.snackbar(
      'Notification',
      'Opened: ${notification.title}',
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
