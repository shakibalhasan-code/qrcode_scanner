import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/core/models/notification_model.dart';

class ApiNotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const ApiNotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image or Icon
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _buildNotificationIcon(),
              ),
            ),

            SizedBox(width: 12.w),

            // Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Text
                  Text(
                    notification.text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4.h),

                  // Notification Type
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          notification.type,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: _getTypeColor(),
                          ),
                        ),
                      ),
                      if (notification.product != null) ...[
                        SizedBox(width: 8.w),
                        Text(
                          'Product related',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Time and Read Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  notification.formattedTime,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),

                SizedBox(height: 8.h),

                // Read/Unread Indicator (Blue dot)
                if (!notification.read)
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AFF), // Blue color like in the image
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    if (notification.product?.image != null &&
        notification.product!.image.isNotEmpty) {
      // Show product image if available
      return Image.network(
        notification.product!.getFullImageUrl(),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultIcon();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildDefaultIcon();
        },
      );
    } else {
      return _buildDefaultIcon();
    }
  }

  Widget _buildDefaultIcon() {
    IconData iconData;
    switch (notification.type.toLowerCase()) {
      case 'offer':
      case 'promotion':
        iconData = Icons.local_offer;
        break;
      case 'order':
        iconData = Icons.shopping_bag;
        break;
      case 'delivery':
        iconData = Icons.local_shipping;
        break;
      case 'user':
      default:
        iconData = Icons.notifications;
        break;
    }

    return Container(
      color: Colors.grey[200],
      child: Icon(iconData, size: 24.w, color: _getTypeColor()),
    );
  }

  Color _getTypeColor() {
    switch (notification.type.toLowerCase()) {
      case 'offer':
      case 'promotion':
        return Colors.orange;
      case 'order':
        return Colors.blue;
      case 'delivery':
        return Colors.green;
      case 'user':
      default:
        return Colors.purple;
    }
  }
}
