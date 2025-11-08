import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';

class HomeCategoriesWidget extends StatelessWidget {
  final List<Category> categories;
  final VoidCallback onSeeAll;
  final Function(Category) onCategoryTap;
  final bool isLoading;

  const HomeCategoriesWidget({
    super.key,
    required this.categories,
    required this.onSeeAll,
    required this.onCategoryTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Categories',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Categories List
          SizedBox(
            height: 100.h,
            child: isLoading
                ? _buildLoadingState()
                : categories.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: GestureDetector(
                          onTap: () => onCategoryTap(category),
                          child: Column(
                            children: [
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: _buildCategoryImage(category),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              SizedBox(
                                width: 60.w,
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryText,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Loading state widget
  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Column(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 60.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 40.sp, color: Colors.grey[400]),
          SizedBox(height: 8.h),
          Text(
            'No categories available',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Helper method to build category image with proper error handling
  Widget _buildCategoryImage(Category category) {
    final String imageUrl = category.getFullImageUrl();

    // Use CachedNetworkImage for better performance
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 35.w,
      height: 35.h,
      fit: BoxFit.contain,
      placeholder: (context, url) => SizedBox(
        width: 35.w,
        height: 35.h,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.grey[400],
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        // Try to load as asset if network fails
        if (!imageUrl.startsWith('http')) {
          return Image.asset(
            imageUrl,
            width: 35.w,
            height: 35.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.category, size: 30.w, color: Colors.grey[400]);
            },
          );
        }
        return Icon(Icons.category, size: 30.w, color: Colors.grey[400]);
      },
    );
  }
}
