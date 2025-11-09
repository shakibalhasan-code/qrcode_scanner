import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';

class ProductDetailsInfo extends StatelessWidget {
  final Product product;

  const ProductDetailsInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.star, size: 16.w, color: Colors.orange),
              SizedBox(width: 4.w),
              Text(
                product.effectiveRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                '(${_getReviewText()})',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            product.getFormattedPrice(),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _getReviewText() {
    final totalReviews = product.totalReviews;
    if (totalReviews == 0) {
      return 'No Reviews';
    } else if (totalReviews >= 1000) {
      return '${(totalReviews / 1000).toStringAsFixed(1)}k+ Reviews';
    } else {
      return '$totalReviews Review${totalReviews > 1 ? 's' : ''}';
    }
  }
}
