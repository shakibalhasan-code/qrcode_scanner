import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/categories/controller/categories_controller.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController(), permanent: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: controller.onBackPressed,
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.w,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Our Categories',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Products Grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 0.h,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.allProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.allProducts[index];
                    return GestureDetector(
                      onTap: () => controller.onProductTap(product),
                      child: Container(
                        // decoration: BoxDecoration(
                        //   color: Colors.grey[50],
                        //   borderRadius: BorderRadius.circular(16.r),
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Expanded(
                              flex: 4,
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(8.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Hero(
                                    tag: product.id,
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2.w,
                                                      color: Colors.grey[400],
                                                    ),
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
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
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Product Info
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
