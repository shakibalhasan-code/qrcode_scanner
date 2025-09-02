import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/notifications/controller/notifications_controller.dart';
import 'package:qr_code_inventory/app/views/main/notifications/widgets/notification_item_widget.dart';
import 'package:qr_code_inventory/app/views/main/notifications/widgets/notification_section_header.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: controller.onBackPressed,
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.w,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          'Notification',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return _buildEmptyNotifications();
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              
              // Today Section
              if (controller.todayNotifications.isNotEmpty) ...[
                const NotificationSectionHeader(title: 'Today'),
                ...controller.todayNotifications.map((notification) =>
                  NotificationItemWidget(
                    notification: notification,
                    onTap: () => controller.onNotificationTap(notification),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              
              // Yesterday Section
              if (controller.yesterdayNotifications.isNotEmpty) ...[
                const NotificationSectionHeader(title: 'Yesterday'),
                ...controller.yesterdayNotifications.map((notification) =>
                  NotificationItemWidget(
                    notification: notification,
                    onTap: () => controller.onNotificationTap(notification),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              
              // Bottom padding
              SizedBox(height: 80.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyNotifications() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_outlined,
            size: 64.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You\'ll see notifications here when you get them',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
