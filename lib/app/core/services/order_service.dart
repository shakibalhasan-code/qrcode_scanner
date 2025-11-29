import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_inventory/app/core/api_endpoints.dart';
import 'package:qr_code_inventory/app/core/models/order_model.dart';

class OrderService extends GetxService {
  final http.Client _httpClient = http.Client();

  /// Create a new order
  Future<OrderResponse> createOrder({
    required List<OrderItem> items,
    required double totalAmount,
    required String token,
  }) async {
    try {
      debugPrint('🚀 OrderService.createOrder() called');
      debugPrint('🔗 URL: ${ApiEndpoints.createOrder}');
      debugPrint('📦 Items count: ${items.length}');
      debugPrint('💰 Total amount: \$${totalAmount.toStringAsFixed(2)}');

      final orderRequest = OrderRequest(items: items, totalAmount: totalAmount);

      final response = await _httpClient.post(
        Uri.parse(ApiEndpoints.createOrder),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(orderRequest.toJson()),
      );

      debugPrint('📊 Response Status: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        debugPrint('✅ Order created successfully');
        return OrderResponse.fromJson(responseData);
      } else {
        final errorData = json.decode(response.body);
        debugPrint('❌ Failed to create order: $errorData');
        return OrderResponse(
          success: false,
          message: errorData['message'] ?? 'Failed to create order',
        );
      }
    } catch (e) {
      debugPrint('❌ Error creating order: ${e.toString()}');
      return OrderResponse(
        success: false,
        message: 'Error creating order: ${e.toString()}',
      );
    }
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
