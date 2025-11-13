import 'product_model.dart';

// Individual notification model matching API response
class NotificationItem {
  final String id;
  final String text;
  final bool read;
  final String type;
  final Product? product;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationItem({
    required this.id,
    required this.text,
    required this.read,
    required this.type,
    this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      read: json['read'] ?? false,
      type: json['type'] ?? 'USER',
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'text': text,
      'read': read,
      'type': type,
      'product': product?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to get formatted time
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Helper method to check if notification is recent (within 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours <= 24;
  }

  // Copy with method for updating notification state
  NotificationItem copyWith({
    String? id,
    String? text,
    bool? read,
    String? type,
    Product? product,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      text: text ?? this.text,
      read: read ?? this.read,
      type: type ?? this.type,
      product: product ?? this.product,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Notification data structure
class NotificationData {
  final List<NotificationItem> result;
  final int unreadCount;

  NotificationData({required this.result, required this.unreadCount});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      result:
          (json['result'] as List<dynamic>?)
              ?.map((item) => NotificationItem.fromJson(item))
              .toList() ??
          [],
      unreadCount: json['unredCount'] ?? 0, // Note: API has typo "unredCount"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.map((item) => item.toJson()).toList(),
      'unredCount': unreadCount,
    };
  }

  // Helper method to get only unread notifications
  List<NotificationItem> get unreadNotifications {
    return result.where((notification) => !notification.read).toList();
  }

  // Helper method to get only read notifications
  List<NotificationItem> get readNotifications {
    return result.where((notification) => notification.read).toList();
  }
}

// API Response wrapper for notifications
class NotificationResponse {
  final bool success;
  final String message;
  final NotificationData data;

  NotificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

// Action response for mark as read/unread operations
class NotificationActionResponse {
  final bool success;
  final String message;

  NotificationActionResponse({required this.success, required this.message});

  factory NotificationActionResponse.fromJson(Map<String, dynamic> json) {
    return NotificationActionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
