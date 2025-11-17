import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_inventory/app/core/api_endpoints.dart';
import 'package:qr_code_inventory/app/core/models/review_model.dart';

class ReviewService {
  // Submit a review for a product
  Future<ReviewResponse> createReview({
    required int rating,
    required String review,
    required String productId,
    required String token,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.createReview);

      final body = {'rating': rating, 'review': review, 'product': productId};

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        debugPrint('Review submitted successfully: $data');
        Get.back(); // Close the bottom sheet
        return ReviewResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        debugPrint('Failed to submit review: $errorData');
        return ReviewResponse(
          success: false,
          message: errorData['message'] ?? 'Failed to submit review',
        );
      }
    } catch (e) {
      return ReviewResponse(
        success: false,
        message: 'Error submitting review: ${e.toString()}',
      );
    }
  }
}
