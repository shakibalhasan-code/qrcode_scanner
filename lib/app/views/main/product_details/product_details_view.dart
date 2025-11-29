import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/views/main/product_details/controller/product_details_controller.dart';
import 'package:qr_code_inventory/app/views/main/product_details/widgets/product_details_header.dart';
import 'package:qr_code_inventory/app/views/main/product_details/widgets/product_details_image.dart';
import 'package:qr_code_inventory/app/views/main/product_details/widgets/product_details_info.dart';
import 'package:qr_code_inventory/app/views/main/product_details/widgets/product_details_qr_section.dart';
import 'package:qr_code_inventory/app/views/main/product_details/widgets/product_details_description.dart';
import 'package:qr_code_inventory/app/views/main/product_details/widgets/product_details_reviews.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailsController(), permanent: false);

    return WillPopScope(
      onWillPop: () async {
        // Clean up controller before popping
        try {
          Get.delete<ProductDetailsController>();
        } catch (e) {
          debugPrint('⚠️ Error deleting ProductDetailsController: $e');
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Obx(() {
            // Show loading state
            if (controller.isLoading.value) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFFFD54F)),
                    SizedBox(height: 16),
                    Text('Loading product details...'),
                  ],
                ),
              );
            }

            // Show error state
            if (controller.hasError.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load product',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: controller.refreshProductDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD54F),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: controller.onBackPressed,
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Show product details if loaded successfully
            if (controller.product == null) {
              return const Center(child: Text('No product data available'));
            }

            return Column(
              children: [
                // Header with back button and favorite
                ProductDetailsHeader(
                  onBack: controller.onBackPressed,
                  onFavoriteToggle: controller.toggleFavorite,
                  isFavorite: controller.isFavorite,
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image with Hero animation
                        ProductDetailsImage(
                          product: controller.product!,
                          heroTag: controller.product!.id,
                        ),

                        SizedBox(height: 24.h),

                        // Product Info (name, rating, price)
                        Obx(
                          () =>
                              ProductDetailsInfo(product: controller.product!),
                        ),

                        // SizedBox(height: 10.h),

                        // // QR Code Section
                        // const ProductDetailsQRSection(),
                        SizedBox(height: 24.h),

                        // Description Section
                        ProductDetailsDescription(product: controller.product!),

                        SizedBox(height: 24.h),

                        // Reviews Section
                        Obx(
                          () => ProductDetailsReviews(
                            product: controller.product,
                          ),
                        ),

                        SizedBox(height: 100.h), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        bottomNavigationBar: Obx(() {
          if (controller.isLoading.value ||
              controller.hasError.value ||
              controller.product == null) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isAddingToCart.value
                    ? null
                    : controller.isProductInCart
                    ? controller.navigateToCart
                    : controller.addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD54F),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 0,
                ),
                child: controller.isAddingToCart.value
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
                        controller.isProductInCart
                            ? 'View Cart'
                            : 'Add to Cart',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
