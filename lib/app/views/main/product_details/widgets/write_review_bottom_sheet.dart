import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/product_details/controller/product_details_controller.dart';

class WriteReviewBottomSheet extends StatefulWidget {
  const WriteReviewBottomSheet({super.key});

  @override
  State<WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends State<WriteReviewBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 5;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Write a Review',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, size: 24.w),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Product name
            if (controller.product != null) ...[
              Text(
                controller.product!.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Rating section
            Text(
              'Your Rating',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),

            // Star rating selector
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Icon(
                      Icons.star,
                      size: 32.w,
                      color: index < _selectedRating
                          ? Colors.orange
                          : Colors.grey[300],
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 8.h),

            // Rating description
            Text(
              _getRatingDescription(_selectedRating),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),

            SizedBox(height: 24.h),

            // Review text field
            Text(
              'Your Review',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),

            TextField(
              controller: _reviewController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Share your experience with this product...',
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFD54F),
                    width: 2,
                  ),
                ),
                counterStyle: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),

            SizedBox(height: 24.h),

            // Submit button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isSubmittingReview.value
                      ? null
                      : () async {
                          if (_reviewController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please write a review',
                              backgroundColor: Colors.orange.withOpacity(0.1),
                              colorText: Colors.orange,
                            );
                            return;
                          }

                          final success = await controller.submitReview(
                            rating: _selectedRating,
                            reviewText: _reviewController.text.trim(),
                          );

                          if (success) {
                            Get.snackbar(
                              'Thank You',
                              'Your review has been submitted',
                              backgroundColor: Colors.green.withOpacity(0.1),
                              colorText: Colors.green,
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Failed to submit your review. Please try again later.',
                              backgroundColor: Colors.red.withOpacity(0.1),
                              colorText: Colors.red,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54F),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: controller.isSubmittingReview.value
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                      : Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingDescription(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}
