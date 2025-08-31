import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/search/controller/search_controller.dart';
import 'package:qr_code_inventory/app/views/main/search/widgets/filter_drawer.dart';
import 'package:qr_code_inventory/app/views/main/search/widgets/search_header_widget.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductSearchController());
    // A key to control the Scaffold (e.g., to open the drawer)
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey, // Assign the key to the Scaffold
      backgroundColor: Colors.white,
      // Use the endDrawer property for a right-side drawer
      endDrawer: const FilterDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            SearchHeaderWidget(
              controller: controller.searchController,
              onBack: controller.onBackPressed,
              onChanged: (value) {},
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() => Row(
                children: [
                  Text(
                    'Showing product of',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 8.w),
                  if (controller.searchQuery.value.isNotEmpty)
                    Chip(
                      label: Text(
                        controller.searchQuery.value,
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                      ),
                      avatar: Icon(Icons.shopping_bag_outlined, size: 16.w),
                      onDeleted: controller.clearFilters,
                      backgroundColor: Colors.grey.shade100,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                    ),
                  const Spacer(),
                  InkWell(
                    // Open the endDrawer when tapped
                    onTap: () => scaffoldKey.currentState?.openEndDrawer(),
                    child: Icon(Icons.tune, size: 24.w, color: Colors.grey[700]),
                  ),
                ],
              )),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() => GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.7,
                ),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final product = controller.searchResults[index];
                  return GestureDetector(
                    onTap: () => controller.onProductTap(product),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: product.image.startsWith('http')
                                  ? Image.network(product.image, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                                  : Image.asset(product.image, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}