import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/api_endpoints.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/views/main/product_details/controller/product_details_controller.dart';
import 'package:qr_code_inventory/app/views/main/product_details/widgets/write_review_bottom_sheet.dart';

class ProductDetailsReviews extends StatefulWidget {
  final Product? product;

  const ProductDetailsReviews({super.key, this.product});

  @override
  State<ProductDetailsReviews> createState() => _ProductDetailsReviewsState();
}

class _ProductDetailsReviewsState extends State<ProductDetailsReviews> {
  bool isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when 80% scrolled
      final controller = Get.find<ProductDetailsController>();
      if (!controller.isLoadingReviews.value &&
          controller.hasMoreReviews.value) {
        controller.loadMoreReviews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();

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

          // Rating Summary - Use Obx to reactively update when product changes
          Obx(() {
            final product = controller.product;
            final totalReviews = controller.totalReviews.value;

            // Debug log
            debugPrint('🎨 ProductDetailsReviews rendering...');
            debugPrint('   Product: ${product?.name}');
            debugPrint('   Effective rating: ${product?.effectiveRating}');
            debugPrint('   Total reviews (getter): ${product?.totalReviews}');
            debugPrint('   Total reviews (controller): $totalReviews');
            debugPrint('   Has ratingStats: ${product?.ratingStats != null}');

            return Row(
              children: [
                Text(
                  product?.effectiveRating.toStringAsFixed(1) ?? '0.0',
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
                          final rating = product?.effectiveRating ?? 0.0;
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
                        '${controller.totalReviews.value} ratings',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          SizedBox(height: 24.h),

          // Rating Breakdown - Use Obx to reactively update
          Obx(() {
            final ratingBars = _buildRatingBars(controller);
            return Column(children: ratingBars);
          }),

          SizedBox(height: 24.h),

          // Reviews List
          if (isExpanded) ...[
            Obx(() {
              if (controller.isLoadingReviews.value &&
                  controller.reviews.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.reviews.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Text(
                      'No reviews yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...controller.reviews.map(
                    (review) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildReviewItem(review),
                    ),
                  ),
                  // Load more indicator
                  if (controller.isLoadingReviews.value)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  // Load more button
                  if (!controller.isLoadingReviews.value &&
                      controller.hasMoreReviews.value)
                    TextButton(
                      onPressed: controller.loadMoreReviews,
                      child: const Text('Load More Reviews'),
                    ),
                ],
              );
            }),
          ] else ...[
            Row(
              children: [
                Obx(
                  () => Text(
                    '${controller.totalReviews.value} Reviews',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Show write review bottom sheet
                    Get.bottomSheet(
                      const WriteReviewBottomSheet(),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
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

  List<Widget> _buildRatingBars(ProductDetailsController controller) {
    final product = controller.product;
    final totalReviews = controller.totalReviews.value;

    // If product has ratingStats, use that data directly
    if (product?.ratingStats != null) {
      final ratingStats = product!.ratingStats!;
      debugPrint('📊 Using ratingStats for rating bars');
      debugPrint('   Total reviews: ${ratingStats.totalReviews}');
      debugPrint('   Counts: ${ratingStats.counts}');
      debugPrint('   Percentages: ${ratingStats.percentages}');

      return List.generate(5, (index) {
        final starLevel = 5 - index;
        final count = ratingStats.counts[starLevel.toString()] ?? 0;
        final percentage =
            (ratingStats.percentages[starLevel.toString()] ?? 0.0) / 100.0;

        debugPrint(
          '🌟 Rating $starLevel: $count reviews (${(percentage * 100).toInt()}%)',
        );

        return _buildRatingBar(starLevel, percentage, count);
      });
    }

    // Fallback: calculate from reviews list if no ratingStats
    final reviews = controller.reviews;
    if (reviews.isEmpty || totalReviews == 0) {
      debugPrint('⚠️ No reviews or ratingStats, showing empty bars');
      return List.generate(5, (index) => _buildRatingBar(5 - index, 0.0, 0));
    }

    debugPrint(
      '📊 Calculating rating distribution from ${reviews.length} reviews',
    );
    final ratingCounts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var review in reviews) {
      final rating = review.rating.clamp(1, 5);
      ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
    }

    return List.generate(5, (index) {
      final starLevel = 5 - index;
      final count = ratingCounts[starLevel] ?? 0;
      final percentage = totalReviews > 0 ? count / totalReviews : 0.0;

      debugPrint(
        '🌟 Rating $starLevel: $count reviews (${(percentage * 100).toInt()}%)',
      );

      return _buildRatingBar(starLevel, percentage, count);
    });
  }

  Widget _buildRatingBar(int stars, double percentage, int count) {
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

  Widget _buildReviewItem(review) {
    final userName = review.user?.name ?? 'Anonymous';
    final userImage = review.user?.image;
    final timeAgo = _formatTimeAgo(review.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // User avatar
            userImage != null
                ? CircleAvatar(
                    radius: 16.r,
                    backgroundImage: NetworkImage(
                      '${ApiEndpoints.imageBaseUrl}$userImage',
                    ),
                    backgroundColor: Colors.grey[300],
                  )
                : CircleAvatar(
                    radius: 16.r,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      userName[0].toUpperCase(),
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
                    userName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    timeAgo,
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
              color: index < review.rating ? Colors.orange : Colors.grey[300],
            );
          }),
        ),
        SizedBox(height: 8.h),
        Text(
          review.review,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
