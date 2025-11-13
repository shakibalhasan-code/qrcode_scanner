import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../api_endpoints.dart';
import '../models/notification_model.dart';

class NotificationService extends GetxService {
  final http.Client _httpClient = http.Client();

  // Get all notifications
  Future<NotificationResponse> getNotifications({required String token}) async {
    debugPrint('🚀 NotificationService.getNotifications() called');
    debugPrint('🔗 URL: ${ApiEndpoints.getNotifications}');

    try {
      final response = await _httpClient.get(
        Uri.parse(ApiEndpoints.getNotifications),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Notifications retrieved successfully');
        return NotificationResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to get notifications: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        return NotificationResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to get notifications: ${response.statusCode}',
          data: NotificationData(result: [], unreadCount: 0),
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in getNotifications: $e');
      return NotificationResponse(
        success: false,
        message: 'Error: ${e.toString()}',
        data: NotificationData(result: [], unreadCount: 0),
      );
    }
  }

  // Update notification (mark as read)
  Future<NotificationActionResponse> updateNotification({
    required String notificationId,
    required String token,
  }) async {
    debugPrint('🚀 NotificationService.updateNotification() called');
    debugPrint('🆔 Notification ID: $notificationId');
    debugPrint('🔗 URL: ${ApiEndpoints.updateNotification}/$notificationId');

    try {
      final response = await _httpClient.patch(
        Uri.parse('${ApiEndpoints.updateNotification}/$notificationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'read': true, // Mark as read
        }),
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Notification updated successfully');
        return NotificationActionResponse.fromJson(responseData);
      } else {
        debugPrint('❌ Failed to update notification: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        return NotificationActionResponse(
          success: false,
          message:
              errorData['message'] ??
              'Failed to update notification: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('💥 Exception in updateNotification: $e');
      return NotificationActionResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
