import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/core/models/wishlist_model.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Remove Button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      ),
                      color: Colors.grey[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      ),
                      child: item.product.image.isNotEmpty
                          ? Image.network(
                              item.product.getFullImageUrl(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                  '🖼️ Failed to load wishlist image: ${item.product.getFullImageUrl()}',
                                );
                                debugPrint('🖼️ Error: $error');
                                return Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 32.w,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Image not found',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  debugPrint(
                                    '✅ Successfully loaded wishlist image: ${item.product.getFullImageUrl()}',
                                  );
                                  return child;
                                }
                                return Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                          : null,
                                      strokeWidth: 2,
                                      color: const Color(0xFFFFD54F),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 32.w,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                    ),
                  ),
                  // Remove button
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(Icons.close, size: 16.w, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      item.product.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4.h),

                    // Category
                    Text(
                      item.product.category.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // const Spacer(),

                    // // Price and Rating
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Text(
                    //         item.product.getFormattedPrice(),
                    //         style: TextStyle(
                    //           fontSize: 16.sp,
                    //           fontWeight: FontWeight.w700,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ),

                    //     // Rating
                    //     Row(
                    //       children: [
                    //         Icon(
                    //           Icons.star,
                    //           size: 14.w,
                    //           color: Colors.orange,
                    //         ),
                    //         SizedBox(width: 2.w),
                    //         Text(
                    //           item.product.effectiveRating.toStringAsFixed(1),
                    //           style: TextStyle(
                    //             fontSize: 12.sp,
                    //             color: Colors.grey[600],
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
