class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String productImage;
  final double originalPrice;
  final double discountedPrice;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.productImage,
    required this.originalPrice,
    required this.discountedPrice,
    required this.timestamp,
    this.isRead = false,
    this.type = NotificationType.offer,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    }
  }

  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? productImage,
    double? originalPrice,
    double? discountedPrice,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      productImage: productImage ?? this.productImage,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}

enum NotificationType {
  offer,
  order,
  delivery,
  general,
}
