import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/assigned_products/controller/all_assigned_products_controller.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';

class AllAssignedProductsView extends StatelessWidget {
  const AllAssignedProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AllAssignedProductsController(),
      permanent: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Assigned Products',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.w, color: Colors.red[400]),
                SizedBox(height: 16.h),
                Text(
                  'Error Loading Products',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: controller.loadAllAssignedProducts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!controller.hasProducts) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64.w,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No assigned products found',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'There are no products assigned yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        // Products list
        return RefreshIndicator(
          onRefresh: controller.loadAllAssignedProducts,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by product, user, or email...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Obx(
                      () => controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: controller.clearSearch,
                            )
                          : const SizedBox.shrink(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),

              // Product count
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Assigned Products',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${controller.productsCount} products',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Products list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final assignedProduct = controller.filteredProducts[index];
                    final product = assignedProduct.productId;
                    final user = assignedProduct.userId;

                    return GestureDetector(
                      onTap: () => controller.onProductTap(assignedProduct),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                product.getFullImageUrl(),
                                width: 80.w,
                                height: 80.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80.w,
                                    height: 80.w,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Name
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),

                                  // Price and Size
                                  Row(
                                    children: [
                                      Text(
                                        product.getFormattedPrice(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: Text(
                                          product.size,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),

                                  // Stock count and rating (if available)
                                  Row(
                                    children: [
                                      if (product.count != null) ...[
                                        Icon(
                                          Icons.inventory_2,
                                          size: 14.w,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Stock: ${product.count}',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                      ],
                                      if (product.rating != null &&
                                          product.rating! > 0) ...[
                                        Icon(
                                          Icons.star,
                                          size: 14.w,
                                          color: Colors.amber,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          product.rating.toString(),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 6.h),

                                  // Assigned User Info
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 12.w,
                                          color: Colors.green[700],
                                        ),
                                        SizedBox(width: 4.w),
                                        Flexible(
                                          child: Text(
                                            'Assigned to: ${user.name}',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Arrow icon
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                              color: Colors.grey[400],
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
      }),
    );
  }
}
