import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final bool isLoading;
  final VoidCallback? onRetry;
  final Function(Category)? onCategoryTap;
  final Category? selectedCategory;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.isLoading = false,
    this.onRetry,
    this.onCategoryTap,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Icon(Icons.category_outlined, size: 40.sp, color: Colors.grey),
            SizedBox(height: 8.h),
            Text(
              'No categories available',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 8.h),
              ElevatedButton(onPressed: onRetry, child: Text('Retry')),
            ],
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategory?.id == category.id;

        return GestureDetector(
          onTap: () => onCategoryTap?.call(category),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.accent : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: isSelected
                  ? AppColors.accent.withOpacity(0.1)
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Category Image
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: CachedNetworkImage(
                      imageUrl: category.getFullImageUrl(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.category, color: Colors.grey, size: 30.sp),
                      placeholder: (context, url) => Icon(
                        Icons.category,
                        color: Colors.grey.shade400,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Category Name
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.primaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryHorizontalList extends StatelessWidget {
  final List<Category> categories;
  final bool isLoading;
  final VoidCallback? onRetry;
  final Function(Category)? onCategoryTap;
  final Category? selectedCategory;

  const CategoryHorizontalList({
    super.key,
    required this.categories,
    this.isLoading = false,
    this.onRetry,
    this.onCategoryTap,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 120.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (categories.isEmpty) {
      return Container(
        height: 120.h,
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 30.sp, color: Colors.grey),
            SizedBox(height: 8.h),
            Text(
              'No categories available',
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 8.h),
              ElevatedButton(
                onPressed: onRetry,
                child: Text('Retry', style: TextStyle(fontSize: 10.sp)),
              ),
            ],
          ],
        ),
      );
    }

    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory?.id == category.id;

          return GestureDetector(
            onTap: () => onCategoryTap?.call(category),
            child: Container(
              width: 100.w,
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.accent : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12.r),
                color: isSelected
                    ? AppColors.accent.withOpacity(0.1)
                    : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Category Image
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.r),
                      child: CachedNetworkImage(
                        imageUrl: category.getFullImageUrl(),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          Icons.category,
                          color: Colors.grey,
                          size: 24.sp,
                        ),
                        placeholder: (context, url) => Icon(
                          Icons.category,
                          color: Colors.grey.shade400,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Category Name
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.primaryText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
