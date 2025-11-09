import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';

class ProductDetailsReviews extends StatefulWidget {
  final Product? product;

  const ProductDetailsReviews({super.key, this.product});

  @override
  State<ProductDetailsReviews> createState() => _ProductDetailsReviewsState();
}

class _ProductDetailsReviewsState extends State<ProductDetailsReviews> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 24.w,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Rating Summary
          Row(
            children: [
              Text(
                widget.product?.effectiveRating.toStringAsFixed(1) ?? '0.0',
                style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OUT OF 5',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: List.generate(5, (index) {
                        final rating = widget.product?.effectiveRating ?? 0.0;
                        return Icon(
                          Icons.star,
                          size: 20.w,
                          color: index < rating
                              ? Colors.orange
                              : Colors.grey[300],
                        );
                      }),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${widget.product?.totalReviews ?? 0} ratings',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Rating Breakdown
          ..._buildRatingBars(),

          SizedBox(height: 24.h),

          // Reviews List
          if (isExpanded) ...[
            _buildReviewItem(
              'Jhon',
              '20m ago',
              'I love it. Awesome customer service!! Helped me out with adding an additional item to my order. Thanks again!',
              5,
            ),
            SizedBox(height: 16.h),
            _buildReviewItem(
              'Rihana',
              '30m ago',
              'I\'m very happy with order. It was delivered on and good quality. Recommended!',
              5,
            ),
          ] else ...[
            Row(
              children: [
                Text(
                  '${widget.product?.totalReviews ?? 0} Reviews',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle write review
                  },
                  child: Row(
                    children: [
                      Text(
                        'Write A Review',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.edit, size: 16.w, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildRatingBars() {
    if (widget.product?.ratingStats == null) {
      // If no rating stats, show default empty bars
      return List.generate(5, (index) => _buildRatingBar(5 - index, 0.0));
    }

    final ratingStats = widget.product!.ratingStats!;
    final totalReviews = ratingStats.totalReviews;

    return List.generate(5, (index) {
      final starLevel = 5 - index;
      final count = ratingStats.counts['$starLevel'] ?? 0;
      final percentage = totalReviews > 0 ? count / totalReviews : 0.0;
      return _buildRatingBar(starLevel, percentage);
    });
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(Icons.star, size: 16.w, color: Colors.orange),
          SizedBox(width: 4.w),
          Text(
            stars.toString(),
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String time, String review, int rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16.r,
              backgroundColor: Colors.grey[300],
              child: Text(
                name[0],
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              size: 14.w,
              color: index < rating ? Colors.orange : Colors.grey[300],
            );
          }),
        ),
        SizedBox(height: 8.h),
        Text(
          review,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
