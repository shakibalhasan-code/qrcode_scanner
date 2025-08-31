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
    final controller = Get.put(ProductDetailsController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                      product: controller.product,
                      heroTag: controller.product.id,
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Product Info (name, rating, price)
                    ProductDetailsInfo(
                      product: controller.product,
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // QR Code Section
                    const ProductDetailsQRSection(),
                    
                    SizedBox(height: 24.h),
                    
                    // Description Section
                    ProductDetailsDescription(
                      product: controller.product,
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Reviews Section
                    const ProductDetailsReviews(),
                    
                    SizedBox(height: 100.h), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
        child: ElevatedButton(
          onPressed: controller.addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD54F),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Add to Cart',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
